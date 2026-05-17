## Base routines for the Nitty terminal emulator
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[monotimes, os, posix, strutils, tables, times]
import pkg/[vmath, shakar, chronicles, chroma, pixie]
import pkg/surfer/app, pkg/ybus/client/unix_sync
import bindings/[libvterm]
when defined(libnittyTerse):
  import terse/[machine, parser, types]

import
  ./[
    coloring, config, grid, input, renderer, fonts, font_metrics, screen, spawner, types
  ],
  ./dbus/notifications

let screenCallbacks {.global.} = VTermScreenCallbacks(
  settermprop: proc(
      prop: VTermProp, val: ptr VTermValue, user: pointer
  ): int32 {.cdecl.} =
    debug "Set terminal property", prop = prop

    setTerminalProperty(cast[Terminal](user), prop, val),
  bell: proc(user: pointer): int32 {.cdecl.} =
    let terminal = cast[Terminal](user)
    if terminal.useBell:
      debug "Ring system bell"
      ringSystemBell(terminal.app)
    else:
      debug "Got bell op, ignoring."
  ,
  damage: proc(rect: VTermRect, user: pointer): int32 {.cdecl.} =
    cast[Terminal](user).dirty = true,
)

let allocator {.global.} = VTermAllocatorFunctions(
  malloc: proc(size: uint64, _: pointer): pointer {.cdecl.} =
    alloc0(size),
  free: proc(buffer: pointer, _: pointer) {.cdecl.} =
    dealloc(buffer),
)

proc initializeBackend(terminal: Terminal) =
  ## Initialize the underlying terminal state machine.
  debug "Initializing libvterm"
  terminal.vterm.vt = vterm_new_with_allocator(20, 30, allocator.addr, allocdata = nil)
  vterm_set_utf8(terminal.vterm.vt, true)

  terminal.vterm.state = vterm_obtain_state(terminal.vterm.vt)

  terminal.vterm.screen = vterm_obtain_screen(terminal.vterm.vt)
  vterm_screen_reset(terminal.vterm.screen, 1'i32)
  vterm_screen_set_damage_merge(terminal.vterm.screen, VTermDamagesize.Cell)

  vterm_screen_set_callbacks(
    terminal.vterm.screen, screenCallbacks.addr, cast[ptr TerminalObj](terminal)
  )
  vterm_output_set_callback(
    terminal.vterm.vt,
    proc(buff: ConstCStr, size: uint64, user: pointer) {.cdecl.} =
      # debugecho "write(" & repr($buff) & ')'
      let terminal = cast[Terminal](user)
      discard write(terminal.vterm.fds.master, buff[0].addr, size.int),
    cast[ptr TerminalObj](terminal),
  )

  when defined(libnittyTerse):
    terminal.machine = initMachine(20, 30)

proc initializeDBus(terminal: Terminal) =
  ## Initialize a connection to the user's bus session
  if terminal.args.disableDBus:
    warn "Not initializing connection to DBus. Some features will not be available."
    return

  terminal.bus = newBusClient()
  terminal.bus.connect()

  info "Connected to DBus session",
    serial = terminal.bus.serial, uniqueName = terminal.bus.uniqueName

proc initializeLayerWidget(terminal: Terminal): bool =
  ## Initialize Nitty as a layer-shell widget.

  # Firstly, parse the configuration file provided to us.
  let layerConfigOpt = loadLayerConfig(name = &terminal.args.layerWidgetConfigPath)
  if !layerConfigOpt:
    return false

  let layerConfig = &layerConfigOpt
  info "Creating layer widget",
    cmd = layerConfig.exec.cmd,
    layer = layerConfig.surface.layer,
    anchors = layerConfig.surface.anchors,
    size = layerConfig.surface.size,
    keyboardInteractivity = layerConfig.surface.keyboardInteractivity

  let
    layerStr = toLowerAscii(layerConfig.surface.layer)
    interStr = toLowerAscii(layerConfig.surface.keyboardInteractivity)

  var
    layer: Layer
    anchors: set[Anchor]
    size: vmath.IVec2
    keyboardInteractivity: KeyboardInteractivity

  let fullExecPath =
    if isAbsolute(layerConfig.exec.cmd):
      layerConfig.exec.cmd
    else:
      findExe(layerConfig.exec.cmd)

  if fullExecPath.len < 1:
    error "Cannot resolve executable for widget", cmd = layerConfig.exec.cmd
    return false

  if layerStr == "background":
    layer = Layer.Background
  elif layerStr == "bottom":
    layer = Layer.Bottom
  elif layerStr == "top":
    layer = Layer.Top
  elif layerStr == "overlay":
    layer = Layer.Overlay
  else:
    error "Unknown layer for widget", layer = layerConfig.surface.layer
    return false

  for anchor in layerConfig.surface.anchors:
    let anchorStr = toLowerAscii(anchor)
    if anchorStr == "top":
      anchors.incl(Anchor.Top)
    elif anchorStr == "bottom":
      anchors.incl(Anchor.Bottom)
    elif anchorStr == "left":
      anchors.incl(Anchor.Left)
    elif anchorStr == "right":
      anchors.incl(Anchor.Right)
    else:
      error "Unknown anchor for widget", anchor = anchor
      return false

  size = cast[vmath.IVec2](cast[array[2, int32]](layerConfig.surface.size))
    # Using proper routines for conversion? Nah.

  if interStr == "none":
    keyboardInteractivity = KeyboardInteractivity.None
  elif interStr == "exclusive":
    keyboardInteractivity = KeyboardInteractivity.Exclusive
  elif interStr == "on_demand":
    keyboardInteractivity = KeyboardInteractivity.OnDemand
  else:
    error "Unknown keyboard interactivity for widget",
      interactivity = layerConfig.surface.keyboardInteractivity
    return false

  let namespace = "libnitty.widget." & &terminal.args.layerWidgetConfigPath

  info "Creating layer shell widget",
    layer = layer,
    anchors = anchors,
    interactivity = keyboardInteractivity,
    namespace = namespace,
    requestedSize = size

  terminal.shell = ensureMove(fullExecPath)

  terminal.app.createLayerSurface(
    layer = ensureMove(layer),
    anchors = ensureMove(anchors),
    keyboardInteractivity = ensureMove(keyboardInteractivity),
    namespace = namespace,
    renderer = Renderer.GLES,
    requestedSize = ensureMove(size),
  )
  return true

proc initializeApp(terminal: Terminal): bool =
  ## Initialize the Surfer context so we can actually show the terminal grid to
  ## the user. This also handles layer widgets.
  debug "Initializing surfer app"
  terminal.app = newApp("Nitty", appId = "xyz.xtrayambak.nitty")
  terminal.app.controlFlow =
    if getEnv("NITTY_LOOP_METHOD", "wait").toLowerAscii() == "async":
      ControlFlow.Async
    else:
      ControlFlow.Wait
  terminal.app.initialize()

  info "Creating window", features = terminal.app.features

  if !terminal.args.layerWidgetConfigPath:
    # If no widget config path is provided in arguments,
    # we can just behave like a usual terminal emulator.
    terminal.app.createWindow(ivec2(680, 480), Renderer.GLES)
    terminal.app.vsync = true
  else:
    # If a configuration IS provided, we need to parse it and then accordingly
    # create a layer shell surface based off of it.
    if Feature.LayerShell notin terminal.app.features:
      error "Cannot create layer widget as the host compositor does not support it (or atleast, it doesn't advertise support for it). Sorry :("
      return false

    return initializeLayerWidget(terminal)

  debug "App init completed"
  return true

proc initialize*(terminal: Terminal) =
  initializeBackend(terminal)
  initializeDBus(terminal)
  if *terminal.args.program:
    terminal.shell = &terminal.args.program

  assert(
    initializeApp(terminal),
    "App initialization failed. Check the above errors for more information.",
  )

  spawn(terminal)

proc notify*(terminal: Terminal, summary, body: string, avoidSpam: bool = false) =
  if terminal.bus == nil:
    warn "Cannot send notification to user, either the user bus is not running, or the user specifically asked for us to not connect to it."
    return

  terminal.lastNotificationId = terminal.bus.notify(
    "xyz.xtrayambak.nitty",
    (
      if *terminal.lastNotificationId and avoidSpam: &terminal.lastNotificationId
      else: 0'u32
    ),
    "",
    summary,
    body,
    @[],
    initTable[string, Variant](),
    0,
  )

proc run*(terminal: Terminal) =
  var hwRenderer: HWRenderer

  terminal.computeTermGrid(terminal.app.windowSize)
  terminal.resize()

  while not terminal.app.closureRequested:
    let eventOpt = terminal.app.flushQueue()
    if !eventOpt:
      continue

    # FIXME: I'm not exactly sure if this is the best way to read from the pty slave.
    var buf: array[4096, char]
    let n = read(terminal.vterm.fds.master, buf[0].addr, sizeof(buf))
    if n > 0:
      when not defined(nittyDontValidateUTF):
        if not simdutf.validateUTF8(buf[0].addr, cast[uint64](n)):
          warn "Cannot process incoming data as valid UTF-8, passing it to state machine anyways...",
            count = n
          terminal.notify(
            summary = "Cannot process data as UTF8",
            body =
              "The terminal has hit pieces of data that could not be validated as well-formed UTF8. There is a chance that the terminal will lag, show garbled text, or otherwise misbehave. Good luck.",
            avoidSpam = true,
          )

      when defined(libnittyTerse):
        terminal.machine.parser.eat(
          ParserInput(
            data: cast[ptr UncheckedArray[uint8]](buf[0].addr), size: cast[uint64](n)
          )
        )
      discard vterm_input_write(terminal.vterm.vt, buf[0].addr, uint64(n))

    let event = &eventOpt
    case event.kind
    of EventKind.RedrawRequested:
      if not hwRenderer.isInvalid:
        renderTerminal(hwRenderer)

      let currentTime = getMonoTime()

      terminal.fps =
        1000'f32 / float32(inMilliseconds(currentTime - terminal.lastRenderTime))

      terminal.lastRenderTime = currentTime
      terminal.app.queueRedraw()
    of EventKind.KeyPressed, EventKind.KeyRepeated:
      handleKeyInput(terminal, event.key.code)
      terminal.dirty = true
    of EventKind.WindowResized:
      terminal.computeTermGrid(event.windowSize)
      terminal.resize()
      terminal.dirty = true

      if hwRenderer.isInvalid:
        hwRenderer = initHWRenderer(terminal)
          # HACK: For layer shell widgets to work, we cannot initiate GL before the layer surface gets a configuration callback. And that is signified by a resize event being emitted.
    of EventKind.PreferredRenderScale:
      terminal.preferredRenderScale = float32(event.preferredScale) / 120'f32
      info "Got preferred rendering scale", scale = terminal.preferredRenderScale
      terminal.dirty = true
    of EventKind.KeyboardFocusObtained:
      if terminal.reportFocus:
        vterm_state_focus_in(terminal.vterm.state)
    of EventKind.KeyboardFocusLost:
      if terminal.reportFocus:
        vterm_state_focus_out(terminal.vterm.state)
    of EventKind.CursorMove:
      handleMouseMove(terminal, event.cursor.pos.x, event.cursor.pos.y)
    of EventKind.CursorClick:
      handleMouseClick(terminal, event.cursor.button, event.cursor.state)
    of EventKind.CursorFocusObtained:
      terminal.app.setCursorShape(Shape.Text)
    else:
      discard

  info "The event loop has stopped. Alvida."
  discard close(terminal.vterm.fds.master)

proc createTerminal*(args: TerminalArgs): Terminal =
  debug "Initializing terminal emulator"
  discard initFontConfig()

  var term = Terminal(
    font: readFont(&findUsableFont(false)),
    cursorVisible: true,
    preferredRenderScale: 1.0f,
    palette: buildColorPalette(),
    args: args,
  )
  applyConfig(term, loadConfig())

  return term
