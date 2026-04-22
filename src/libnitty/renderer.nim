## Rendering code for the terminal
##
## Copyright (C) 2025-2026 Trayambak Rai (xtrayambak@disroot.org)
#!fmt: off
import pkg/surfer/types
import ./[types],
       swrender/core,
       hwrender/core
#!fmt: on

export SWRenderer, renderSWCursor # CPU renderer
export HWRenderer, initHWRenderer, renderTerminal # GPU renderer

{.push inline.}
proc clearScreen*(terminal: Terminal) =
  if terminal.app.renderer == Renderer.Software:
    clearSWScreen(terminal)
  else:
    discard

proc processDamage*(terminal: Terminal, swCtx: var SWRenderer) =
  if terminal.app.renderer == Renderer.Software:
    processSWDamage(terminal, swCtx)
  else:
    discard

{.pop.}
