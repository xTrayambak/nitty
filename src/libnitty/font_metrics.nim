import std/importutils
import pkg/pixie
import ./types

privateAccess(pixie.Typeface)
privateAccess(pixie.Context)

type FontMetrics* = object
  scale*: float32
  cellWidth*: float32
  cellHeight*: float32

func computeFontMetrics*(font: Font): FontMetrics =
  var metrics = FontMetrics()
  metrics.scale = font.size / float32(font.typeface.opentype.head.unitsPerEm)
  metrics.cellWidth = float32(font.typeface.opentype.os2.xAvgCharWidth) * metrics.scale
  metrics.cellHeight =
    float32(
      font.typeface.opentype.hhea.ascender - font.typeface.opentype.hhea.descender +
        font.typeface.opentype.hhea.lineGap
    ) * metrics.scale

  ensureMove(metrics)
