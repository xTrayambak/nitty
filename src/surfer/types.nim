import std/[monotimes, options]
import platform
import pkg/vmath

when usingPlatform(Wayland):
  import
    pkg/nayland/types/display,
    pkg/nayland/types/protocols/core/
      [buffer, compositor, keyboard, pointer, registry, shm, shm_pool, seat, surface],
    pkg/nayland/types/protocols/xdg_shell/[wm_base, xdg_surface, xdg_toplevel],
    pkg/nayland/types/egl

  import pkg/xkb

when usingPlatform(Wayland):
  type Pools* = object
    cursorPool*: ShmPool
    surfacePool*: ShmPool
    surface*: Buffer
      # TODO: We'll eventually need to support multiple buffers when we add multi-toplevel support
    cursor*: Buffer

    surfaceDest*: pointer
    cursorDest*: pointer

    surfacePoolSize*: int32
    surfacePoolFd*: int32

type
  AppError* = object of OSError
  AppInitError* = object of AppError

  EventKind* {.pure, size: sizeof(uint16).} = enum
    RedrawRequested = 0
    KeyboardFocusObtained = 1
    KeyboardFocusLost = 2
    KeyReleased = 3
    KeyPressed = 4
    KeyRepeated = 5
    WindowResized = 6

  KeyState* {.pure, size: sizeof(uint8).} = enum
    Released = 0
    Pressed = 1
    Repeated = 2

  KeyEvent* = object
    code*: uint32
    time*: uint32

  Event* = object
    case kind*: EventKind
    of {EventKind.KeyReleased, EventKind.KeyPressed, EventKind.KeyRepeated}:
      key*: KeyEvent
    of {EventKind.WindowResized}:
      windowSize*: IVec2
    else:
      discard

  ControlFlow* {.size: sizeof(uint8), pure.} = enum
    ## `ControlFlow` lets the programmer decide between two modes of
    ## the event queue pumping mechanism.
    ##
    ## `ControlFlow.Wait` — this is the default mode. In this, the event queue
    ## blocks until it receives new events from the compositor. It consumes
    ## less CPU power than the succeeding mode, at the cost of blocking the
    ## entire thread as it waits for all new events to show up. It is recommended for
    ## programs which do not need very high graphical throughput, like simple GUIs,
    ## terminal emulators, etc.
    Wait = 0
    ##
    ## `ControlFlow.Async` — this is the second mode. In it, the event queue
    ## asynchronously polls the compositor for events. It consumes more CPU power than
    ## the preceding mode, but it ensures that the thread does _not_ block as it waits
    ## for new events to flow in. It is recommended for applications where
    ## high-performance is necessary, like games, 3D CADs, video players, etc.
    Async = 1

  Renderer* {.pure, size: sizeof(uint8).} = enum
    ## The `Renderer` enum lets you decide whether to use a
    ## software renderer or a hardware rendering API.
    ## 
    ## On Wayland, if a software renderer is used, a
    ## `wl_buffer` will be allocated for drawing.
    Software = 0
    GLES = 1

  AppObj* = object
    when usingPlatform(Wayland):
      display*: Display
      registry*: Registry
      compositor*: Compositor
      seat*: Seat
      xdgWmBase*: WMBase
      keyboard*: Keyboard
      wpointer*: Pointer
      shm*: Shm
      pools*: Pools
      eglWindow*: EGLWindow

      surfaces*: seq[Surface]
      xdgSurfaces*: seq[XDGSurface]
      xdgToplevels*: seq[XDGToplevel]

      xkbContext*: ptr XkbContext
      keymap*: ptr XkbKeymap
      xkbState*: ptr XkbState

      nextWindowSize: Option[IVec2]

      keyboardRepeatDelay: int32
      keyboardRepeatRate: int32

    title, appId: string
    controlFlow*: ControlFlow
    queue: seq[Event]

    windowSize: IVec2

    focused: bool
    closureRequested: bool

    repeatedKey: Option[uint32]
    repeaterStartTime: MonoTime
    lastRepeatSignal: int64

    renderer: Renderer

  App* = ref AppObj

when usingPlatform(Wayland):
  type
    RequiresProtocol* = object of AppInitError
    CannotBindSingleton* = object of AppInitError

    CannotAllocateBuffer* = object of AppError

  func bindingError*(name: string, version: uint32): ref CannotBindSingleton =
    newException(CannotBindSingleton, name & "; version " & $version)

func hasKeyboard*(app: App): bool =
  when usingPlatform(Wayland):
    app.keyboard != nil

func focused*(app: App): bool {.inline, raises: [].} =
  app.focused

func windowSize*(app: App): IVec2 {.inline, raises: [].} =
  app.windowSize

func closureRequested*(app: App): bool {.inline, raises: [].} =
  ## This function returns `true` if the user or compositor
  ## has requested the closure of the app's main toplevel.
  app.closureRequested

func hasCursor*(app: App): bool =
  when usingPlatform(Wayland):
    app.wpointer != nil
