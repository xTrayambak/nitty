## Nitty is a fast terminal emulator written in Nim.
##
## Copyright (C) 2025-2026 Trayambak Rai (xtrayambak@disroot.org)

import libnitty/[argparser, terminal, types]
import pkg/shakar

when not defined(NeoPkgVersion):
  {.
    passC: gorge(
      "pkg-config --cflags wayland-egl wayland-egl-backend glesv2 egl vterm fontconfig"
    )
  .}
  {.
    passL: gorge(
      "pkg-config --libs wayland-egl wayland-egl-backend glesv2 egl vterm fontconfig"
    )
  .}

proc main() {.inline.} =
  let input = parseInput()
  var args: TerminalArgs

  args.drawFPSCounter = input.enabled("draw-fps-counter", "P")
  args.program = input.flag("program")
  args.disableDBus = input.enabled("no-dbus", "L")
  args.layerWidgetConfigPath = input.flag("layer-widget-config")

  let term = createTerminal(args = ensureMove(args))
  term.initialize()
  term.run()

  quit(QuitSuccess)

when isMainModule:
  main()
