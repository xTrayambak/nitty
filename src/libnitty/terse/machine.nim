## Routines for actually handling the state machine.
## This handles the actual grid state and other things.
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import std/[unicode, options]
import pkg/shakar
import ../bindings/simdutf
import ./[types]

func initMachine*(cols, rows: uint32): Machine =
  result = Machine(rows: rows, cols: cols, grid: newSeq[Cell](rows * cols))
  result.parser.machine = result

func resize*(machine: Machine, cols, rows: uint32) =
  machine.rows = rows
  machine.cols = cols
  machine.grid.setLen(rows * cols)

func cellIndex*[T: SomeUnsignedInt](
    machine: Machine, column, row: T
): T {.inline, raises: [].} =
  (row * T(machine.cols)) + column

func cellAt*[T: SomeUnsignedInt](
    machine: Machine, column, row: T
): Option[Cell] {.inline.} =
  let index = machine.cellIndex(column, row)
  if index >= T(machine.grid.len):
    return none(Cell)

  some(machine.grid[index])

func cellAtRef*[T: SomeUnsignedInt](
    machine: Machine, column, row: T
): Option[ptr Cell] {.inline.} =
  ## This is a bit risky. Use it judiciously!
  let index = machine.cellIndex(column, row)
  if index >= T(machine.grid.len):
    return none(ptr Cell)

  some(machine.grid[index].addr)

func saveCursor*(machine: Machine) {.inline.} =
  machine.cursor.savedRow = machine.cursor.row
  machine.cursor.savedCol = machine.cursor.col

func restoreCursor*(machine: Machine) {.inline.} =
  machine.cursor.row = machine.cursor.savedRow
  machine.cursor.col = machine.cursor.savedCol

func handleChar(machine: Machine, c: uint32) =
  if machine.cursor.col >= machine.cols:
    machine.cursor.col = 0'u32
    inc machine.cursor.row

  if machine.cursor.row >= machine.rows:
    machine.cursor.row = machine.rows - 1

  let index = &machine.cellAtRef(machine.cursor.col, machine.cursor.row)
  index.data = c

  debugEcho '(' & $machine.cursor.col & ", " & $machine.cursor.row & ") -> " & $Rune(c)

  inc machine.cursor.col

func handleText*(machine: Machine, str: openArray[char]): uint64 =
  let utfConvResult =
    validateUtf8WithErrors(cast[ptr uint8](str[0].addr), cast[uint64](str.len))

  let npoints = utfConvResult.count
  var size: uint64

  while size < npoints:
    let c = cast[uint8](str[size])
    if c < 0x20'u8 or c == 0x7F'u8:
      break

    inc size

  var eaten: int64
  while eaten < cast[int64](size):
    var rune: unicode.Rune
    unicode.fastRuneAt(str, eaten, rune, doInc = true)

    handleChar(machine, cast[uint32](rune))

  cast[uint64](size)
