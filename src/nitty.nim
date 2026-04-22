import libnitty/terminal

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
  let term = createTerminal()
  term.initializeBackend()
  term.run()

  quit(QuitSuccess)

when isMainModule:
  main()
