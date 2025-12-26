## Routines for handling the event queue
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils, options]
#!fmt: off
import
  pkg/nayland/types/display,
  pkg/nayland/types/protocols/core/[compositor, surface],
  pkg/nayland/types/protocols/xdg_shell/[wm_base, xdg_surface, xdg_toplevel]
#!fmt: on
import pkg/shakar
import ../../types

privateAccess(types.App)

proc flushWaylandQueue*(app: App): Option[Event] =
  if app.controlFlow == ControlFlow.Async:
    # If the app expects an asynchronous events dispatch,
    app.display.roundtrip()
  else:
    # Otherwise, if the app expects a synchronous roundtrip,
    app.display.dispatch()

  # Now, we can just check if one of our handlers placed anything in the queue
  if app.queue.len > 0:
    # If so, just pop and return it.
    result = some(app.queue[0])
    app.queue.delete(0)
  else:
    # Else, return None.
    result = none(Event)
