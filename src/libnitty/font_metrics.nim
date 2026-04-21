import std/importutils
import pkg/pixie
import ./types

privateAccess(pixie.Typeface)
privateAccess(pixie.Context)

type FontMetrics* = object
  scale*: float32
  cellWidth*: float32
  cellHeight*: float32

func computeFontMetrics*(terminal: Terminal): FontMetrics =
  var metrics = FontMetrics()
  metrics.scale =
    terminal.font.size / float32(terminal.font.typeface.opentype.head.unitsPerEm)
  metrics.cellWidth =
    float32(terminal.font.typeface.opentype.os2.xAvgCharWidth) * metrics.scale
  metrics.cellHeight =
    float32(
      terminal.font.typeface.opentype.hhea.ascender -
        terminal.font.typeface.opentype.hhea.descender +
        terminal.font.typeface.opentype.hhea.lineGap
    ) * metrics.scale

  ensureMove(metrics)
