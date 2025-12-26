## Types for libnitty
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[importutils]
import pkg/[chroma, vmath, pixie]
import bindings/libvterm
import ../surfer/app
import ./[coloring]

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

  TerminalObj* = object
    app*: App
    vterm*: VTermObj
    palette*: ColorPalette

    buffer*: pixie.Image
    font*: pixie.Font
    damagedRects*: seq[VTermRect]

    backgroundColor*: chroma.ColorRGBA

    cursorPos*: libvterm.VTermPos

    rows*, cols*: int32

  Terminal* = ref TerminalObj

func fullDamage*(terminal: Terminal) =
  terminal.damagedRects &=
    VTermRect(
      startRow: 0, endRow: terminal.rows + 1, startCol: 0, endCol: terminal.cols + 1
    )
