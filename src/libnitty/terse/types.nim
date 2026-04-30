## Types for terse
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)

type
  ParserState* {.pure, size: sizeof(uint8).} = enum
    Normal
    CSILeader
    CSIArgs
    CSIIntermed
    DCSCommand
    OSCCommand
    OSC
    DCSVTerm
    APC
    PM
    SOS

  Terminator* {.pure, size: sizeof(uint8).} = enum
    Bel ## \x07
    ST ## \x1b\x5c

  Parser* = object
    state*: ParserState
    inEscape*: bool

  ParserInput* = object
    data*: ptr UncheckedArray[uint8]
    size*: uint64
