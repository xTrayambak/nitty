## Types for terse
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import pkg/chroma

const
  CSILeaderMax* = 16
  CSIArgMissing* = (1 shl 31) - 1
  CSIArgFlagMore* = (1 shl 31)

  IntermedMax* = 16

type
  Cell* = object
    data*: uint32

    fg*, bg*: ColorRGB

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

  CappedBuffer[K: static int, T] = object
    data*: array[K, T]
    len*: uint64

  CSIPool* = object
    leader*: CappedBuffer[CSILeaderMax, char]
    args*: CappedBuffer[10, uint32]

  ParserPool* = object
    csi*: CSIPool

  Parser* = object
    state*: ParserState
    machine*: Machine # Super professional design, I know.

    inEscape*: bool
    intermed*: CappedBuffer[IntermedMax, char]

    pool*: ParserPool

  ParserInput* = object
    data*: ptr UncheckedArray[uint8]
    size*: uint64

  MachineCursor = object
    row*, col*: uint32
    savedRow*, savedCol*: uint32

  MachineObj = object
    parser*: Parser
    grid*: seq[Cell]

    rows*, cols*: uint32
    cursor*: MachineCursor

  Machine* = ref MachineObj
