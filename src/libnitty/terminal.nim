## Base routines for the Nitty terminal emulator
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[os, posix, importutils, tables, termios]
import pkg/[vmath, shakar, chronicles, chroma, pixie, xkb]
import ../surfer/app
import bindings/libvterm
import ./[coloring, config, grid, input, pty, renderer, fonts, spawner, types]

let screenCallbacks {.global.} = VTermScreenCallbacks(
  damage: proc(rect: VTermRect, user: pointer): int32 {.cdecl.} =
    #[ debug "Received damaged area",
      startRow = rect.startRow,
      endRow = rect.endRow,
      startCol = rect.startCol,
      endCol = rect.endCol ]#

    let terminal = cast[Terminal](user)
    terminal.app.markDamaged()
    terminal.damagedRects &= rect,
  moverect: proc(dest: VTermRect, src: VTermRect, user: pointer): int32 {.cdecl.} =
    let terminal = cast[Terminal](user)
    terminal.damagedRects &= dest
    terminal.damagedRects &= src,
  movecursor: proc(
      pos: VTermPos, oldpos: VTermPos, visible: int32, user: pointer
  ): int32 {.cdecl.} =
    let terminal = cast[Terminal](user)
    invalidateRow(terminal, oldpos.row, oldpos.row + 1)
    invalidateRow(terminal, pos.row, pos.row + 1)
    terminal.cursorPos = pos,
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
    else:
      debug "Unhandled terminal property set-request, ignoring.", prop = prop
  ,
  bell: proc(user: pointer): int32 {.cdecl.} =
    discard # echo "bell"
  ,
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
  sb_clear: proc(user: pointer): int32 {.cdecl.} =
    debug "Clear screen"
    let terminal = cast[Terminal](user)
    clearScreen(terminal),
)

proc initializeBackend*(terminal: Terminal) =
  debug "Initializing libvterm"
  terminal.vterm.vt = vterm_new(180, 130)
  vterm_set_utf8(terminal.vterm.vt, true)

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

proc run*(terminal: Terminal) =
  for i in 0 ..< terminal.buffer.data.len:
    terminal.buffer.data[i] = bgra(80, 80, 80, 10)

  while not terminal.app.closureRequested:
    let eventOpt = terminal.app.flushQueue()
    if !eventOpt:
      continue

    var buf: array[4096, char]
    while (let n = read(terminal.vterm.fds.master, buf[0].addr, sizeof(buf)); n > 0):
      discard vterm_input_write(terminal.vterm.vt, buf[0].addr, uint64(n))

    let event = &eventOpt
    case event.kind
    of EventKind.RedrawRequested:
      case terminal.app.renderer
      of Renderer.Software:
        processDamage(terminal)
        renderCursor(terminal)

        let stride = terminal.buffer.width * sizeof(ColorRGBX)

        for y in 0 ..< terminal.buffer.height:
          copyMem(
            cast[pointer](cast[uint](terminal.app.pools.surfaceDest) + uint(y * stride)),
            addr terminal.buffer.data[y * terminal.buffer.width],
            stride,
          )
      else:
        discard

      terminal.app.queueRedraw()
    of EventKind.KeyPressed, EventKind.KeyRepeated:
      handleKeyInput(terminal, event.key.code)
    of EventKind.WindowResized:
      # echo "Resize to " & $event.windowSize
      terminal.buffer = newImage(event.windowSize.x, event.windowSize.y)

      # echo $cols & 'x' & $rows
      terminal.computeTermGrid(event.windowSize)
      terminal.resize()
    else:
      discard

  debug "The event loop has stopped. Alvida."
  discard close(terminal.vterm.fds.master)

proc createTerminal*(title: string = "Nitty"): Terminal =
  debug "Initializing terminal emulator"
  discard initFontConfig()

  var term = Terminal(
    buffer: newImage(680, 480),
    font: readFont(&findUsableFont(false)),
    palette: buildColorPalette(),
    cursorVisible: true,
  )
  applyConfig(term, loadConfig())
  spawn(term)

  debug "Initializing surfer app"
  term.app = newApp(title, appId = "xyz.xtrayambak.nitty")
  term.app.controlFlow = ControlFlow.Wait
  term.app.initialize()

  debug "Creating window"
  term.app.createWindow(ivec2(680, 480), Renderer.Software)

  return term
