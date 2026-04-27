## Neo lockfile config

when defined(NeoPkgVersion):
  --noNimblePath
  when withDir(thisDir(), system.fileExists("neo.paths")):
    include "neo.paths"

## End of Neo lockfile config

