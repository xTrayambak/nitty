## Rendering code for the terminal
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/importutils
import pkg/pixie
import bindings/libvterm
import ./[coloring, types]

privateAccess(pixie.Typeface)

type FontMetrics* = object
  scale*: float32
  cellWidth*: float32
  cellHeight*: float32

proc clearScreen*(terminal: Terminal) =
  terminal.buffer.fill(bgra(80, 80, 80, 10))

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

proc redrawCell(
    terminal: Terminal,
    ctx: pixie.Context,
    cell: libvterm.VTermScreenCell,
    x, y, cellWidth, cellHeight: float32,
) =
  # First, overdraw the damaged area with the terminal's background color.
  ctx.fillStyle = terminal.backgroundColor
  ctx.fillStyle.blendMode = OverwriteBlend
  ctx.fillRect(
    rect(
      vec2(x - (cellWidth - terminal.font.size), y - cellHeight),
      vec2(cellWidth, cellHeight),
    )
  )

  # Then, if the cell's bg exists, draw it over the damaged area.
  ctx.fillStyle = terminal.toRGBA(cell.bg, terminal.palette, Usage.Background)
  ctx.fillStyle.blendMode = OverwriteBlend
  ctx.fillRect(
    rect(
      vec2(x - (cellWidth - terminal.font.size), y - cellHeight),
      vec2(cellWidth, cellHeight),
    )
  )

  # Then, if there is any text content, draw it.
  ctx.fillStyle = terminal.toRGBA(cell.fg, terminal.palette, Usage.Foreground)
  ctx.fillStyle.blendMode = OverwriteBlend
  ctx.font = terminal.font.typeface.filePath
  ctx.fontSize = terminal.font.size
  ctx.fillText(
    cast[string](cell.chars[0 ..< 6]), vec2(x - (cellWidth - terminal.font.size), y)
  )

proc renderCursor*(terminal: Terminal, position, oldPosition: libvterm.VTermPos) =
  let ctx = newContext(terminal.buffer)
  let
    metrics = computeFontMetrics(terminal)
    cellWidth = metrics.cellWidth
    cellHeight = metrics.cellHeight

    x = (position.col).float32 * cellWidth
    y = (position.row - 1).float32 * cellHeight

  ctx.fillStyle = bgra(255, 255, 255, 255)
  ctx.fillRect(rect(vec2(x, y), vec2(cellWidth, cellHeight)))

  var oldCell: VTermScreenCell
  let
    cellX = oldPosition.col.float32 * cellWidth
    cellY = oldPosition.row.float32 * cellHeight

  discard vterm_screen_get_cell(
    terminal.vterm.screen,
    VTermPos(row: oldPosition.row, col: oldPosition.col),
    oldCell.addr,
  )
  redrawCell(terminal, ctx, oldCell, cellX, cellY, cellWidth, cellHeight)

  echo "(" & $oldPosition.col & ", " & $oldPosition.row & ") -> (" & $position.col & ", " &
    $position.row & ")"

proc processDamage*(terminal: Terminal) =
  if terminal.damagedRects.len < 1:
    return

  let
    metrics = computeFontMetrics(terminal)
    scale = metrics.scale
    cellWidth = metrics.cellWidth
    cellHeight = metrics.cellHeight

  let ctx = newContext(terminal.buffer)

  while terminal.damagedRects.len > 0:
    let
      rect = terminal.damagedRects.pop()
      row = rect.startRow
      col = rect.startCol

    if rect.endRow == row + 1 and rect.endCol == col + 1:
      # Fast path: Single cell
      let
        x = col.float32 * cellWidth
        y = row.float32 * cellHeight

      var cell: VTermScreenCell
      discard vterm_screen_get_cell(
        terminal.vterm.screen, VTermPos(row: row, col: col), cell.addr
      )

      redrawCell(terminal, ctx, cell, x, y, cellWidth, cellHeight)
    else:
      # Slow path: Multiple cells
      for col in col ..< rect.endCol:
        for row in row ..< rect.endRow:
          let
            x = col.float32 * cellWidth
            y = row.float32 * cellHeight

          var cell: VTermScreenCell
          discard vterm_screen_get_cell(
            terminal.vterm.screen, VTermPos(row: row, col: col), cell.addr
          )

          redrawCell(terminal, ctx, ensureMove(cell), x, y, cellWidth, cellHeight)
