## Routines for initializing the Wayland backend
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
#!fmt: off
import
  pkg/nayland/bindings/protocols/[core, xdg_shell],
  pkg/nayland/types/display,
  pkg/nayland/types/protocols/core/[compositor, registry, seat, shm],
  pkg/nayland/types/protocols/xdg_shell/[wm_base, xdg_surface, xdg_toplevel]
#!fmt: on
import ../../types, ./input
import pkg/shakar

proc checkRequiredProtocols(registry: Registry) =
  # debugecho "Registry::checkRequiredProtocols()"
  template expectProtocol(proto: string) =
    if proto notin registry:
      raise newException(
        types.RequiresProtocol,
        "surfer requires the `" & proto &
          "` protocol to initialize itself. Your compositor either does not support it, or does not advertise it correctly to clients.",
      )

  expectProtocol("wl_compositor")
  expectProtocol("wl_seat")
  expectProtocol("wl_shm")
  expectProtocol("xdg_wm_base")

proc bindCompositor(app: App) =
  # debugecho "App::bindCompositor()"
  let iface = app.registry["wl_compositor"]
  let boundIface =
    app.registry.bindInterface(iface.name, wl_compositor_interface.addr, iface.version)

  if boundIface == nil:
    raise bindingError("wl_compositor", iface.version)

  app.compositor = initCompositor(boundIface)

proc bindXdgWmBase(app: App) =
  # debugecho "App::bindXdgWmBase()"
  let iface = app.registry["xdg_wm_base"]
  let boundIface =
    app.registry.bindInterface(iface.name, xdg_wm_base_interface.addr, iface.version)

  if boundIface == nil:
    raise bindingError("xdg_wm_base", iface.version)

  app.xdgWmBase = initWmBase(boundIface)

proc initializeWaylandSeat*(app: App)

proc bindSeat(app: App) =
  # debugecho "App::bindSeat()"
  let iface = app.registry["wl_seat"]
  let boundIface =
    app.registry.bindInterface(iface.name, wl_seat_interface.addr, iface.version)

  if boundIface == nil:
    raise bindingError("wl_seat", iface.version)

  app.seat = initSeat(boundIface)

  # TODO: Ideally, we should do the init of pointers and keyboards
  # AFTER we get the capabilities event, but eh, this'll suffice
  # for now (hopefully :P).
  initializeWaylandSeat(app)

proc bindShm(app: App) =
  # debugEcho echo "App::bindShm()"
  let iface = app.registry["wl_shm"]
  let boundIface =
    app.registry.bindInterface(iface.name, wl_shm_interface.addr, iface.version)

  if boundIface == nil:
    raise bindingError("wl_shm", iface.version)

  app.shm = initShm(boundIface)

proc bindRequiredSingletons(app: App) =
  # debugecho "App::bindRequiredSingletons()"
  bindCompositor(app)
  bindSeat(app)
  bindXdgWmBase(app)
  bindShm(app)

proc initializeWaylandSeat*(app: App) =
  let keyb = app.seat.getKeyboard()
  if *keyb:
    app.keyboard = &keyb

  let pointer = app.seat.getPointer()
    # Why couldn't we have `ptr void`? I guess we just can't have nice things. :(
  if *pointer:
    app.wpointer = &pointer

proc initializeWaylandBackend*(app: App) =
  ## This routine initializes the Wayland backend and its required objects.
  # debugecho "App::initializeWaylandBackend()"

  # Firstly, we need to connect to the comp.
  # If there is none, nayland will just throw a `CannotConnect`
  app.display = connectDisplay()

  # Since the display search was successfull, we can now init our registry

  app.registry = initRegistry(app.display)

  # Now, we need to do a roundtrip so our registry gets populated with all
  # the protocols that our host compositor advertises.
  app.display.roundtrip()

  # and with that, our initialization is mostly done. Now, we just need to
  # do a few sanity checks to ensure we're on a supported compositor
  # (a la a compositor that supports some basic protocols) and then establish
  # a few singletons so we can do stuff like creating surfaces.
  checkRequiredProtocols(app.registry)

  # Now, let's just create a compositor singleton.
  bindRequiredSingletons(app)

  # Initialize Wayland input subsystem
  initializeWaylandInput(app)
