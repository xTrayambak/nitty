import surfer/app
import libnitty/terminal
import pkg/[vmath, shakar, chroma, pixie]

proc main() {.inline.} =
  let term = createTerminal()
  term.initializeBackend()
  term.run()

  quit(QuitSuccess)

when isMainModule:
  main()
