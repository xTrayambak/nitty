## Pseudoterminal spawner routine
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[os, posix, tables, termios]
import pkg/chronicles
import ./[pty, types, meta]

logScope:
  topics = "libnitty spawner"

proc enableMasterEcho(master: int32) =
  debug "Enabling master echo flag"
  var termSettings: Termios
  discard tcgetattr(master, termSettings.addr)
  termSettings.c_lflag = termSettings.c_lflag or ECHO
  discard tcsetattr(master, TCSANOW, termSettings.addr)

proc reapplyEnvVars(environ: Table[string, string]) =
  debug "Reapplying environment variables"
  for key, value in environ:
    putEnv(key, value)

  # It's a nice idea to export some environment variables, similar
  # to what WezTerm does, plus some extras.
  debug "Applying nitty-specific environment variables"
  putEnv("NITTY_EXECUTABLE_DIR", os.getAppDir())
  putEnv("NITTY_EXECUTABLE", os.getAppFilename())
  putEnv("NITTY_VERSION", meta.Version)

proc spawn*(terminal: Terminal) =
  debug "Spawning master and child fds"

  debug "Preserving environment snapshot"
  var environ: Table[string, string]
  for key, val in envPairs():
    # debug "Preserving environment variable", key = key, value = val
    environ[key] = val

  var master, child: int32
  discard openpty(master.addr, child.addr, nil, nil, nil)

  debug "Created pseudoterminal file descriptor pairs", master = master, child = child

  # Enable echo'ing in the master
  enableMasterEcho(master)

  debug "Forking for creation of child process"
  let pid = fork()

  if pid == 0:
    reapplyEnvVars(environ)

    let shell =
      if not isAbsolute(terminal.shell):
        findExe(terminal.shell)
      else:
        terminal.shell
    debug "Shell path. We're soon handing over control to the shell. Adios!",
      name = terminal.shell, path = shell

    discard close(master)

    # Start a new session and become its leader.
    discard setsid()

    discard ioctl(FileHandle(child), uint(TIOCSCTTY), 0)

    discard dup2(child, getOsFileHandle(stdout))
    discard dup2(child, getOsFileHandle(stdin))
    discard dup2(child, getOsFileHandle(stderr))

    discard close(child)

    putEnv("TERM", "xterm-256color")
    putEnv("COLORTERM", "truecolor")
    putEnv("SHELL", shell)

    if shell.len > 0:
      discard posix.execlp(cstring(shell), cstring(terminal.shell), nil)
      quit(QuitFailure)
    else:
      error "Failed to execute shell program. Cannot find it in PATH!",
        shell = terminal.shell

      while true:
        discard pause()
  else:
    debug "We're the main process, continuing initialization", childPid = pid
    discard posix.fcntl(
      master, posix.F_SETFL, posix.fcntl(master, posix.F_GETFL, 0) or O_NONBLOCK
    )

    terminal.vterm.fds.master = ensureMove(master)
    terminal.vterm.fds.child = ensureMove(child)
