## Everything to do with input sources and events on Wayland
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils, posix]
import
  pkg/nayland/bindings/protocols/core,
  pkg/nayland/types/protocols/core/[keyboard, pointer, surface],
  pkg/[shakar, xkb]
import ../../types

privateAccess(types.App)

proc initializeWaylandKeymap(app: App, format: uint32, fd: int32, size: uint32) =
  app.xkbContext = newXkbContext(XkbContextFlags.NoFlags)

  # Now, we need to map the fd into memory.
  # TODO: The docs say that MAP_PRIVATE must be used after v7,
  # and no major compositor seems to be using any version below v9,
  # so I think we're good. Otherwise, we'd have to use MAP_SHARED.
  let buffer = posix.mmap(nil, size.int, PROT_READ, MAP_PRIVATE, fd, 0)
  if buffer == cast[pointer](-1):
    # TODO: This deserves its own error object.
    raise newException(
      CannotAllocateBuffer,
      "Cannot mmap XKB keymap provided by compositor (size=" & $size & ", fd=" & $fd &
        "): " & $strerror(errno) & " (errno " & $errno & ')',
    )

  app.keymap = newFromBufferXkbKeymap(
    app.xkbContext,
    cast[cstring](buffer),
    size.csize_t,
    XkbKeymapFormat(format),
    XkbKeymapCompileFlags.NoFlags,
  )

  if app.keymap == nil:
    raise newException(OSError, "Failed to compile keymap provided by compositor!")

  app.xkbState = newXkbState(app.keymap)

proc initializeWaylandKeyboard(app: App) =
  app.keyboard.onKeymap = proc(
      keyboard: Keyboard, fmt: uint32, fd: int32, size: uint32
  ) =
    initializeWaylandKeymap(app, format = fmt, fd = fd, size = size)

  app.keyboard.onEnter = proc(
      keyboard: Keyboard, serial: uint32, surface: Surface, keys: seq[uint32]
  ) =
    app.focused = true
    app.queue &= Event(kind: EventKind.KeyboardFocusObtained)

  app.keyboard.onLeave = proc(keyboard: Keyboard, serial: uint32, surface: Surface) =
    app.focused = false
    app.queue &= Event(kind: EventKind.KeyboardFocusLost)

  app.keyboard.onKey = proc(
      keyboard: Keyboard, serial: uint32, time: uint32, key: uint32, state: uint32
  ) =
    case KeyState(state)
    of KeyState.Released:
      app.queue &=
        Event(kind: EventKind.KeyReleased, key: KeyEvent(code: key, time: time))
    of KeyState.Pressed:
      app.queue &=
        Event(kind: EventKind.KeyPressed, key: KeyEvent(code: key, time: time))
    of KeyState.Repeated:
      app.queue &=
        Event(kind: EventKind.KeyRepeated, key: KeyEvent(code: key, time: time))

  app.keyboard.onModifiers = proc(
      keyboard: Keyboard,
      serial: uint32,
      modsDepressed, modsLatched, modsLocked, group: uint32,
  ) =
    discard app.xkbState.updateMask(
      cast[XkbModMask](modsDepressed),
      cast[XkbModMask](modsLatched),
      cast[XkbModMask](modsLocked),
      0'u32,
      0'u32,
      group,
    )

  app.keyboard.onRepeatInfo = proc(keyboard: Keyboard, rate, delay: int32) =
    assert(rate > 0'i32)
    assert(delay > 0'i32)

  app.keyboard.attachCallbacks()

proc initializeWaylandInput*(app: App) =
  if hasKeyboard(app):
    initializeWaylandKeyboard(app)
