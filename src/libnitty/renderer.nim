## Rendering code for the terminal
##
## Copyright (C) 2025-2026 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils]
import pkg/[shakar, pixie], pkg/surfer/types
import bindings/libvterm
import ./[coloring, types], ./swrender/core

export SWRenderer

{.push inline.}
proc clearScreen*(terminal: Terminal) =
  if terminal.app.renderer == Renderer.Software:
    clearSWScreen(terminal)
  else:
    unreachable

proc processDamage*(terminal: Terminal, swCtx: var SWRenderer) =
  if terminal.app.renderer == Renderer.Software:
    processSWDamage(terminal, swCtx)
  else:
    unreachable

{.pop.}
