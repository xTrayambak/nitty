when defined(NeoPkgVersion) or defined(UseNeoDeps):
  ## Neo lockfile config

  --noNimblePath
  when withDir(thisDir(), system.fileExists("neo.paths")):
    include "neo.paths" ## End of Neo lockfile config

when defined(NimblePkgVersion):
  # begin Nimble config (version 2)
  --noNimblePath
  when withDir(thisDir(), system.fileExists("nimble.paths")):
    include "nimble.paths" # end Nimble config
