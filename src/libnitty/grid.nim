## Utilities to work with the screen grid
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import ./[types, pty, font_metrics]
import bindings/libvterm, terse/machine
import pkg/[pixie, vmath]

func computeTermGrid*(terminal: Terminal, windowSize: IVec2) =
  let
    metrics = computeFontMetrics(terminal.font)
    cols = int32(windowSize.x.float32 / metrics.cellWidth)
    rows = int32(windowSize.y.float32 / metrics.cellHeight)

  terminal.fontMetrics = metrics
  terminal.rows = rows
  terminal.cols = cols

proc resize*(terminal: Terminal) =
  vterm_set_size(terminal.vterm.vt, terminal.rows, terminal.cols)
  when defined(libnittyTerse):
    terminal.machine.resize(uint32 terminal.rows, uint32 terminal.cols)

  var ws = winsize(wsRow: uint16(terminal.rows), wsCol: uint16(terminal.cols))
  discard pty.ioctl(terminal.vterm.fds.master, TIOCSWINSZ, ws.addr)
  terminal.dirty = true
