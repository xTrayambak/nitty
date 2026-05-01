## Types for libnitty
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils, monotimes, options]
import pkg/[chroma, pixie]
import bindings/libvterm, terse/types, ./font_metrics
import pkg/surfer/app, pkg/ybus/client/unix_sync

privateAccess(pixie.Typeface)

type
  ColorPalette* = array[256, chroma.ColorRGBA]

  TermFds = object
    master*, child*: int32

  VTermObj = object
    vt*: ptr VTerm
    screen*: ptr VTermScreen
    state*: ptr VTermState

    fds*: TermFds

  TerminalArgs* = object
    drawFPSCounter*: bool
    program*: Option[string] ## Program to run instead of the shell
    disableDBus*: bool

  TerminalObj* = object
    app*: App
    bus*: BusClient

    vterm*: VTermObj
    palette*: ColorPalette

    font*: pixie.Font
    backgroundColor*: chroma.ColorRGBA

    cursorVisible*: bool

    rows*, cols*: int32
    cursorRow*, cursorCol*: int32

    mouseMode*: VTermMouseProp
    reportFocus*: bool

    shell*: string
    useBell*: bool

    preferredRenderScale*: float32
    dirty*: bool
    lastRenderTime*: MonoTime
    fps*: float32

    fontMetrics*: FontMetrics
    args*: TerminalArgs

    lastNotificationId*: Option[uint32]

    parser*: Parser

  Terminal* = ref TerminalObj
