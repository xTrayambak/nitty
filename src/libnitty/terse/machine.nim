## Routines for actually handling the state machine.
## This handles the actual grid state and other things.
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import ./[types, parser]

func initMachine*(rows, cols: uint32): Machine =
  Machine(rows: rows, cols: cols, grid: newSeq[Cell](rows * cols))

func resize*(machine: Machine, rows, cols: uint32) =
  machine.rows = rows
  machine.cols = cols
  machine.grid.setLen(rows * cols)
