## Utilities for handling terminal colors
## 
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)

import bindings/libvterm
import pkg/[chroma, shakar]
import ./types

type Usage* {.pure, size: sizeof(uint8).} = enum
  Foreground = 0 ## This color will be used for text
  Background = 1 ## This color will be used for the background

func bgra*(r, g, b: uint8, a: uint8 = 150'u8): chroma.ColorRGBA =
  rgba(b, g, r, a)

func bgra*(c: chroma.ColorRGBA): chroma.ColorRGBA =
  rgba(c.b, c.g, c.r, c.a)

func buildColorPalette*(): ColorPalette =
  var palette: ColorPalette
  palette[0] = bgra(0, 0, 0)
  palette[1] = bgra(205, 0, 0)
  palette[2] = bgra(0, 205, 0)
  palette[3] = bgra(205, 205, 0)
  palette[4] = bgra(0, 0, 238)
  palette[5] = bgra(205, 0, 205)
  palette[6] = bgra(0, 205, 205)
  palette[7] = bgra(229, 229, 229)
  palette[8] = bgra(127, 127, 127)
  palette[9] = bgra(255, 0, 0)
  palette[10] = bgra(0, 255, 0)
  palette[11] = bgra(255, 255, 0)
  palette[12] = bgra(92, 92, 255)
  palette[13] = bgra(255, 0, 255)
  palette[14] = bgra(0, 255, 255)
  palette[15] = bgra(255, 255, 255)

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
    rgba(b(c), g(c), r(c), alpha)
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
