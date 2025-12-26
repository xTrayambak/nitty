## Utilities to work with the screen grid
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import ./[types, pty, renderer]
import bindings/libvterm
import pkg/[pixie, vmath]

func computeTermGrid*(terminal: Terminal, windowSize: IVec2) =
  let
    metrics = computeFontMetrics(terminal)
    cols = int32(windowSize.x.float32 / metrics.cellWidth)
    rows = int32(windowSize.y.float32 / metrics.cellHeight)

  terminal.rows = rows
  terminal.cols = cols

proc resize*(terminal: Terminal) =
  vterm_set_size(terminal.vterm.vt, terminal.rows, terminal.cols)

  var ws = winsize(wsRow: uint16(terminal.rows), wsCol: uint16(terminal.cols))
  discard pty.ioctl(terminal.vterm.fds.master, TIOCSWINSZ, ws.addr)

  # Tell the renderer to redraw all cells
  terminal.buffer.fill(terminal.backgroundColor)
  terminal.fullDamage()
