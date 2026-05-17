## Screen operations
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import pkg/chronicles, pkg/surfer/app
import bindings/libvterm
import ./types

proc setTerminalProperty*(terminal: Terminal, prop: VTermProp, val: ptr VTermValue) =
  case prop
  of VTermProp.Title:
    let title = $val.string
    debug "Setting window title from callback", title = title

    if terminal.app.xdgToplevels.len > 0:
      # Only attempt to set the title if we're not a layer shell surface.
      terminal.app.setTitle(title)
  of VTermProp.CursorVisible:
    terminal.cursorVisible = val.boolean
  of VTermProp.Mouse:
    terminal.mouseMode = cast[VTermMouseProp](val.number)
  of VTermProp.FocusReport:
    terminal.reportFocus = val.boolean
  else:
    debug "Unhandled terminal property set-request, ignoring.", prop = prop
