## `<pty.h>` bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
when not defined(unix):
  {.error: "This cannot be compiled on non-POSIX systems".}

import std/[posix, termios]

{.push header: "<sys/ioctl.h>".}

type winsize* {.importc: "struct $1".} = object
  ws_row*, ws_col*, ws_xpixel*, ws_ypixel*: uint16

proc ioctl*(fd: int32, v: int32, a: pointer): int32 {.importc.}

{.pop.}

{.push header: "<termios.h>", importc.}

{.pop.}

{.push importc, header: "<pty.h>".}

let
  TIOCSCTTY*: int32
  TIOCSWINSZ*: int32

proc openpty*(
  amaster: ptr int32,
  aslave: ptr int32,
  name: cstring,
  termios: ptr Termios,
  winp: ptr winsize,
): int32 {.sideEffect.}

proc forkpty*(
  amaster: ptr int32, name: cstring, termios: ptr Termios, winp: ptr winsize
)

{.pop.}
