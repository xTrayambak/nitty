## Base routines for the Nitty terminal emulator
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[monotimes, os, posix, strutils, tables, times]
import pkg/[vmath, shakar, chronicles, chroma, pixie]
import pkg/surfer/app, pkg/ybus/client/unix_sync
import bindings/[libvterm, simdutf]
import
  ./[coloring, config, grid, input, renderer, fonts, font_metrics, spawner, types],
  ./dbus/notifications

let screenCallbacks {.global.} = VTermScreenCallbacks(
  settermprop: proc(
      prop: VTermProp, val: ptr VTermValue, user: pointer
  ): int32 {.cdecl.} =
    debug "Set terminal property", prop = prop

    let terminal = cast[Terminal](user)

    case prop
    of VTermProp.Title:
      let title = $val.string
      debug "Setting window title from callback", title = title
      terminal.app.setTitle(title)
    of VTermProp.CursorVisible:
      terminal.cursorVisible = val.boolean
    of VTermProp.Mouse:
      terminal.mouseMode = cast[VTermMouseProp](val.number)
    of VTermProp.FocusReport:
      terminal.reportFocus = val.boolean
    else:
      debug "Unhandled terminal property set-request, ignoring.", prop = prop
  ,
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
  resize: proc(rows: int32, cols: int32, user: pointer): int32 {.cdecl.} =
    discard # echo "resize"
  ,
  sb_pushline: proc(
      cols: int32, cells: ptr ConstVTermScreenCell, user: pointer
  ): int32 {.cdecl.} =
    discard # echo "sb_pushline"
  ,
  sb_popline: proc(
      cols: int32, cells: ptr VTermScreenCell, user: pointer
  ): int32 {.cdecl.} =
    discard # echo "sb_popline"
  ,
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

proc initializeDBus(terminal: Terminal) =
  ## Initialize a connection to the user's bus session
  if terminal.args.disableDBus:
    warn "Not initializing connection to DBus. Some features will not be available."
    return

  terminal.bus = newBusClient()
  terminal.bus.connect()

  info "Connected to DBus session",
    serial = terminal.bus.serial, uniqueName = terminal.bus.uniqueName

proc initialize*(terminal: Terminal, args: TerminalArgs) =
  terminal.args = args
  initializeBackend(terminal)
  initializeDBus(terminal)

  if *terminal.args.program:
    terminal.shell = &terminal.args.program

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
  var hwRenderer = initHWRenderer(terminal)

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

      discard vterm_input_write(terminal.vterm.vt, buf[0].addr, uint64(n))

    let event = &eventOpt
    case event.kind
    of EventKind.RedrawRequested:
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
      when defined(setCursorShape):
        # HACK: Every time I decide I was too harsh on Nimble, I get proven wrong.
        # EVERY. SINGLE. TIME.
        terminal.app.setCursorShape(CursorShape.Text)
    else:
      discard

  info "The event loop has stopped. Alvida."
  discard close(terminal.vterm.fds.master)

proc createTerminal*(title: string = "Nitty"): Terminal =
  debug "Initializing terminal emulator"
  discard initFontConfig()

  var term = Terminal(
    font: readFont(&findUsableFont(false)),
    cursorVisible: true,
    preferredRenderScale: 1.0f,
    palette: buildColorPalette(),
  )
  applyConfig(term, loadConfig())

  debug "Initializing surfer app"
  term.app = newApp(title, appId = "xyz.xtrayambak.nitty")
  term.app.controlFlow =
    if getEnv("NITTY_LOOP_METHOD", "wait").toLowerAscii() == "async":
      ControlFlow.Async
    else:
      ControlFlow.Wait
  term.app.initialize()

  debug "Creating window"
  term.app.createWindow(ivec2(680, 480), Renderer.GLES)

  return term
