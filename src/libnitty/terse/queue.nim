## Event queue implementation for Terse
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)

const MaxBufferSize* {.intdefine: "TerseMaxEventBufferSize".} = 4096

type
  TerminalEventKind* {.pure, size: sizeof(uint8).} = enum
    Bell

  TerminalEvent* = object
    case kind* {.bitsize: 7.}: TerminalEventKind
    else: discard
    valid* {.bitsize: 1.}: bool

  Queue* = object
    buffer*: array[MaxBufferSize, TerminalEvent]
