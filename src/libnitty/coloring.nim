## Utilities for handling terminal colors
## 
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)

import bindings/libvterm
import pkg/[chroma, shakar]
import ./types

type Usage* {.pure, size: sizeof(uint8).} = enum
  Foreground = 0 ## This color will be used for text
  Background = 1 ## This color will be used for the background

func buildColorPalette*(): ColorPalette =
  func rgba(r, g, b: uint8, a: uint8 = 150'u8): chroma.ColorRGBA {.inline.} =
    chroma.rgba(r, g, b, a)

  var palette: ColorPalette
  palette[0] = rgba(0, 0, 0)
  palette[1] = rgba(205, 0, 0)
  palette[2] = rgba(0, 205, 0)
  palette[3] = rgba(205, 205, 0)
  palette[4] = rgba(0, 0, 238)
  palette[5] = rgba(205, 0, 205)
  palette[6] = rgba(0, 205, 205)
  palette[7] = rgba(229, 229, 229)
  palette[8] = rgba(127, 127, 127)
  palette[9] = rgba(255, 0, 0)
  palette[10] = rgba(0, 255, 0)
  palette[11] = rgba(255, 255, 0)
  palette[12] = rgba(92, 92, 255)
  palette[13] = rgba(255, 0, 255)
  palette[14] = rgba(0, 255, 255)
  palette[15] = rgba(255, 255, 255)

  ensureMove(palette)

func toRGBA*(
    terminal: Terminal, c: libvterm.VTermColor, palette: ColorPalette, usage: Usage
): chroma.ColorRGBA =
  let alpha =
    if usage == Usage.Background:
      # If the usage is for the background,
      # we must inherit the base background's
      # alpha component.
      terminal.backgroundColor.a
    else:
      # Otherwise, if it is to be used
      # for the foreground, we must ensure
      # the text transparency is 100%.
      255'u8

  if isRGB(c):
    rgba(c.r, c.g, c.b, alpha)
  elif isDefaultFG(c):
    rgba(0, 0, 0, alpha)
  elif isDefaultBG(c):
    terminal.backgroundColor
  elif isIndexed(c):
    var color = palette[c.idx]
    color.a = alpha

    ensureMove(color)
  else:
    unreachable
    rgba(0, 0, 0, 0)
