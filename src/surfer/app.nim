## App functions
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils, options]
import ./[platform, types]
import pkg/vmath

when usingPlatform(Wayland):
  #!fmt: off
  import
    pkg/nayland/types/display,
    pkg/nayland/types/protocols/core/[compositor, registry]
  #!fmt: on

  import backend/wayland/prelude

privateAccess(types.App)

proc initialize*(app: App) =
  # echo "App::initialize"
  when usingPlatform(Wayland):
    initializeWaylandBackend(app)

proc createWindow*(app: App, dimensions: vmath.IVec2, renderer: Renderer) =
  # echo "App::createWindow(" & $dimensions & ", Renderer." & $renderer & ')'
  app.windowSize = dimensions

  when usingPlatform(Wayland):
    createWaylandWindow(app, dimensions, renderer)

proc flushQueue*(app: App): Option[Event] =
  # echo "App::flushQueue()"
  when usingPlatform(Wayland):
    flushWaylandKeyboardEvents(app)
    flushWaylandQueue(app)

proc queueRedraw*(app: App) =
  # echo "App::queueRedraw()"
  when usingPlatform(Wayland):
    queueRedrawWayland(app)

proc setTitle*(app: App, title: string) =
  when usingPlatform(Wayland):
    setWaylandTitle(app, title)

proc markDamaged*(app: App) =
  when usingPlatform(Wayland):
    markWaylandDamaged(app)

proc newApp*(title: string = "Surfer", appId: string = "xyz.xtrayambak.surfer"): App =
  App(title: title, appId: appId)

export types
