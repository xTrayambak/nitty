## Compile-time information we can get from flags
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)

when defined(NeoPkgVersion):
  const Version* {.strdefine: "NeoPkgVersion".} = "<not defined>"
elif defined(NimblePkgVersion):
  const Version* {.strdefine: "NimblePkgVersion".} = "<not defined>"
