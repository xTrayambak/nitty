## GPU-based renderer implementation for Nitty, using NanoVG.
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import std/[math, monotimes, times]
import
  pkg/[chroma, nanovg, pixie, vmath],
  pkg/nanovg/wrapper,
  pkg/surfer/types,
  pkg/surfer/backend/wayland/bindings/[egl, gles2]
import ../[coloring, font_metrics, types], ../bindings/[libvterm]

type
  CachedFB = object
    fb: NVGLUFramebuffer
    dimensions: IVec2

  HWRenderer* = object
    terminal*: Terminal
    ctx*: nanovg.NVGContext

    lastFPSMeterDrawTime: MonoTime
    trackedFps: float32

    cache: CachedFB

func toNVG(c: chroma.ColorRGBA): nanovg.Color =
  const inv = 0.00392156862745098'f32 # ~ 1.0 / 255.0
  nanovg.Color(
    r: c.r.float32 * inv,
    g: c.g.float32 * inv,
    b: c.b.float32 * inv,
    a: c.a.float32 * inv,
  )

proc renderCell(
    hw: var HWRenderer, cell: sink VTermScreenCell, x, y, width, height: float32
) =
  # Draw the background
  hw.ctx.beginPath()
  hw.ctx.rect(x, y, width, height)
  hw.ctx.fillColor(
    toNVG(toRGBA(hw.terminal, cell.bg, hw.terminal.palette, Usage.Background))
  )
  hw.ctx.fill()

  hw.ctx.beginPath()
  hw.ctx.fontSize(hw.terminal.font.size)
  hw.ctx.fontFace("main")

  hw.ctx.fillColor(
    toNVG(toRGBA(hw.terminal, cell.fg, hw.terminal.palette, Usage.Foreground))
  )
  discard hw.ctx.text(x, y, cast[cstring](cell.chars[0].addr), nil)

proc renderCursor(hw: var HWRenderer, cursor: VTermPos) =
  hw.ctx.beginPath()
  hw.ctx.rect(
    float32(cursor.col + 1) * hw.terminal.fontMetrics.cellWidth,
    float32(cursor.row) * hw.terminal.fontMetrics.cellHeight,
    4'f32,
    hw.terminal.fontMetrics.cellHeight,
  )
  hw.ctx.fillColor(rgb(200, 200, 200))
  hw.ctx.fill()

proc drawTerminal(hw: var HWRenderer) =
  let renderDimensions = hw.terminal.app.windowSize

  # If the size is the same as before, we needn't reallocate the FBOs
  if renderDimensions != hw.cache.dimensions:
    if hw.cache.fb != nil:
      nvgluDeleteFramebuffer(hw.cache.fb)

    const ifNoDelete = 1'i32 shl 16'i32

    hw.cache.fb = nvgluCreateFramebuffer(
      hw.ctx,
      renderDimensions.x,
      renderDimensions.y,
      cast[int32](ifNoDelete or cast[int32](ifPremultiplied)),
    )
    hw.cache.dimensions = renderDimensions

  nvgluBindFramebuffer(hw.cache.fb)
  glViewport(0, 0, renderDimensions.x, renderDimensions.y)
  glClearColor(0.0, 0.0, 0.0, 0.0)
  glClear(GL_COLOR_BUFFER_BIT or GL_STENCIL_BUFFER_BIT)

  hw.ctx.beginFrame(
    float32(renderDimensions.x),
    float32(renderDimensions.y),
    hw.terminal.preferredRenderScale,
  )

  hw.ctx.beginPath()
  hw.ctx.fillColor(toNVG(hw.terminal.backgroundColor))
  hw.ctx.rect(0, 0, float32(renderDimensions.x), float32(renderDimensions.y))
  hw.ctx.fill()

  var rows, cols: int32
  vterm_get_size(hw.terminal.vterm.vt, rows.addr, cols.addr)

  for row in 0 ..< rows:
    for col in 0 ..< cols:
      let
        x = float32(col + 1) * hw.terminal.fontMetrics.cellWidth
        y = float32(row + 1) * hw.terminal.fontMetrics.cellHeight

      var cell: VTermScreenCell
      discard vterm_screen_get_cell(
        hw.terminal.vterm.screen, VTermPos(row: row, col: col), cell.addr
      )

      renderCell(
        hw,
        ensureMove(cell),
        x,
        y,
        hw.terminal.fontMetrics.cellWidth,
        hw.terminal.fontMetrics.cellHeight,
      )

  # Cursor rendering
  if hw.terminal.cursorVisible:
    var cursorPos: VTermPos
    vterm_state_get_cursorpos(hw.terminal.vterm.state, cursorPos.addr)
    renderCursor(hw, ensureMove(cursorPos))

  hw.ctx.endFrame()
  nvgluBindFramebuffer(nil)

proc renderTerminal*(hw: var HWRenderer) =
  if hw.terminal.dirty:
    drawTerminal(hw)
    hw.terminal.dirty = false

  let dimensions = hw.cache.dimensions
  glViewport(0, 0, dimensions.x, dimensions.y)
  glClearColor(0.0, 0.0, 0.0, 0.0)
  glClear(GL_COLOR_BUFFER_BIT or GL_STENCIL_BUFFER_BIT)

  hw.ctx.beginFrame(
    float32(dimensions.x), float32(dimensions.y), hw.terminal.preferredRenderScale
  )
  hw.ctx.beginPath()
  hw.ctx.rect(0'f32, 0'f32, float32(dimensions.x), float32(dimensions.y))
  hw.ctx.fillPaint(
    hw.ctx.imagePattern(
      0, 0, float32(dimensions.x), float32(dimensions.y), 0, hw.cache.fb.image, 1.0'f32
    )
  )
  hw.ctx.fill()

  # Performance stats
  if hw.terminal.args.drawFPSCounter:
    let ctime = getMonoTime()
    if inMilliseconds(ctime - hw.lastFPSMeterDrawTime) >= 500:
      hw.trackedFps = hw.terminal.fps
      hw.lastFPSMeterDrawTime = ctime

    hw.ctx.beginPath()
    hw.ctx.fontSize(24)
    hw.ctx.fontFace("main")
    hw.ctx.fillColor(rgb(0, 255, 0))
    discard hw.ctx.text(16, 32, cstring($int(hw.trackedFps)), nil)

  hw.ctx.endFrame()

proc initHWRenderer*(terminal: Terminal): HWRenderer =
  assert(
    terminal.app.renderer == Renderer.GLES,
    "Attempt to initialize HWRenderer while using non-GLES backend!",
  )

  nvgInit(eglGetProcAddress)

  var hw = HWRenderer(
    terminal: terminal, ctx: nanovg.nvgCreateContext({nifDebug, nifStencilStrokes})
  )
  discard hw.ctx.createFont("main", hw.terminal.font.typeface.filePath)
    # FIXME: This is wasteful, as we're:
    # 1. Forcing pixie to parse the font
    # 2. Then, forcing NanoVG to parse it.
    # Maybe we can just parse font skipping in config code if the GPU backend
    # is detected, but that'll probably require a bit of refactoring. :P

  ensureMove(hw)
