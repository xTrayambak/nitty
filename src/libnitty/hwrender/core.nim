## GPU-based renderer implementation for Nitty, using NanoVG.
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import std/[math, monotimes, times]
import
  pkg/[chroma, nanovg, pixie, vmath],
  pkg/nanovg/wrapper,
  pkg/surfer/types,
  pkg/surfer/backend/wayland/bindings/[egl, gles2]
import ../[coloring, font_metrics, types], ../bindings/libvterm

type HWRenderer* = object
  terminal*: Terminal
  ctx*: nanovg.NVGContext

  lastFPSMeterDrawTime: MonoTime
  trackedFps: float32

  font: FontMetrics

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

  # Draw the cell's text data, if any is present.
  if cell.chars[0] != 0'u32:
    hw.ctx.beginPath()
    hw.ctx.fontSize(hw.terminal.font.size)
    hw.ctx.fontFace("main")

    hw.ctx.fillColor(
      toNVG(toRGBA(hw.terminal, cell.fg, hw.terminal.palette, Usage.Foreground))
    )
    discard hw.ctx.text(x, y, cast[cstring](cell.chars[0].addr), nil)

proc renderTerminal*(hw: var HWRenderer) =
  glViewport(0, 0, hw.terminal.app.windowSize.x, hw.terminal.app.windowSize.y)
  glClearColor(0, 0, 0, 0)
  glClear(GL_COLOR_BUFFER_BIT)

  hw.ctx.beginFrame(
    float32(hw.terminal.app.windowSize.x),
    float32(hw.terminal.app.windowSize.y),
    hw.terminal.preferredRenderScale,
  )

  hw.ctx.beginPath()
  hw.ctx.fillColor(toNVG(hw.terminal.backgroundColor))
  hw.ctx.rect(
    0, 0, float32(hw.terminal.app.windowSize.x), float32(hw.terminal.app.windowSize.y)
  )
  hw.ctx.fill()

  var rows, cols: int32
  vterm_get_size(hw.terminal.vterm.vt, rows.addr, cols.addr)

  for row in 0 ..< rows:
    for col in 0 ..< cols:
      let
        x = float32(col + 1) * hw.font.cellWidth
        y = float32(row + 1) * hw.font.cellHeight

      var cell: VTermScreenCell
      discard vterm_screen_get_cell(
        hw.terminal.vterm.screen, VTermPos(row: row, col: col), cell.addr
      )

      renderCell(hw, ensureMove(cell), x, y, hw.font.cellWidth, hw.font.cellHeight)

  let ctime = getMonoTime()
  if inMilliseconds(ctime - hw.lastFPSMeterDrawTime) >= 500:
    hw.trackedFps = hw.terminal.fps
    hw.lastFPSMeterDrawTime = ctime

  # Performance stats
  hw.ctx.beginPath()
  hw.ctx.fontSize(24)
  hw.ctx.fontFace("main")
  hw.ctx.fillColor(rgb(0, 255, 0))
  discard hw.ctx.text(16, 32, $int(hw.trackedFps), nil)

  hw.ctx.endFrame()

proc initHWRenderer*(terminal: Terminal): HWRenderer =
  assert(
    terminal.app.renderer == Renderer.GLES,
    "Attempt to initialize HWRenderer while using non-GLES backend!",
  )

  nvgInit(eglGetProcAddress)

  var hw = HWRenderer(
    terminal: terminal, ctx: nvgCreateContext(), font: computeFontMetrics(terminal)
  )
  discard hw.ctx.createFont("main", hw.terminal.font.typeface.filePath)
    # FIXME: This is wasteful, as we're:
    # 1. Forcing pixie to parse the font
    # 2. Then, forcing NanoVG to parse it.
    # Maybe we can just parse font skipping in config code if the GPU backend
    # is detected, but that'll probably require a bit of refactoring. :P

  ensureMove(hw)
