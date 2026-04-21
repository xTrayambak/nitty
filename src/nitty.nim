import libnitty/terminal

proc main() {.inline.} =
  let term = createTerminal()
  term.initializeBackend()
  term.run()

  quit(QuitSuccess)

when isMainModule:
  main()
