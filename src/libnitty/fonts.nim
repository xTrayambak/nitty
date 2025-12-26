## System fonts handler
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
import pkg/chronicles
import bindings/fontconfig

logScope:
  topics = "libnitty font manager"

proc initFontConfig*(): bool {.inline.} =
  debug "Initializing fontconfig"
  FcInit()

proc findUsableFont*(tryMono: bool = true): Option[string] =
  let conf = FcConfigGetCurrent()
  let pattern = FcPatternCreate()

  if tryMono:
    FcPatternAddInteger(pattern, FC_SPACING, FC_MONO)
    FcPatternAddString(pattern, FC_FAMILY, cstring("monospace"))

  discard FcConfigSubstitute(conf, pattern, FC_MATCH_PATTERN)
  FcDefaultSubstitute(pattern)

  var res: FcResult
  let match = FcFontMatch(conf, pattern, res.addr)

  if match == nil:
    FcPatternDestroy(pattern)
    return none(string)

  var file: ptr FcChar8
  if FcPatternGetString(match, FC_FILE, 0, file.addr) == FcResult.Match:
    return some($cast[cstring](file))
  else:
    return findUsableFont(tryMono = false)

proc findFontPath*(name: string): Option[string] =
  let pattern = FcNameParse(cast[ptr FcChar8](cstring(name)))
  if pattern == nil:
    return none(string)

  let conf = FcConfigGetCurrent()
  var res: FcResult
  let match = FcFontMatch(conf, pattern, res.addr)

  if match == nil:
    error "Failed to find font", name = name

    FcPatternDestroy(pattern)
    return none(string)

  var file: ptr FcChar8
  if FcPatternGetString(match, FC_FILE, 0, file.addr) == FcResult.Match:
    return some($cast[cstring](file))
  else:
    return none(string)
