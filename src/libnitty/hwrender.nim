## EGL renderer
##
## The CPU renderer is a-OK for most cases, but it completely dies when running something
## like `sl` or `htop` with a lot of cells.
##
## The GPU renderer simply maintains a map of different renderables, and this makes
## drawing a cell as cheap as creating a quad, which is insanely efficient on GPUs.
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
