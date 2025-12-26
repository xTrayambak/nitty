## Fontconfig bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)

{.push header: "<fontconfig/fontconfig.h>".}

type
  FcBool* {.importc.} = bool
  FcConfig* {.importc.} = object
  FcPattern* {.importc.} = object

  FcResult* {.importc, pure.} = enum
    Match
    NoMatch
    TypeMismatch
    NoId
    OutOfMemory

  FcChar8* {.importc: "unsigned char".} = char

  FcObjectSet* {.importc.} = object
  FcFontSet* {.importc.} = object
    nfont*: int32
    sfont*: int32
    fonts*: ptr UncheckedArray[ptr FcPattern]

{.push importc.}
let
  FC_FAMILY*: cstring
  FC_FILE*: cstring
  FC_SPACING*: cstring
  FC_PROPORTIONAL*: int32
  FC_DUAL*: int32
  FC_MONO*: int32
  FcMatchPattern*: int32

proc FcInit*(): FcBool {.sideEffect.}
proc FcConfigGetCurrent*(): ptr FcConfig

proc FcPatternCreate*(): ptr FcPattern
{.push discardable.}
proc FcPatternAddString*(pattern: ptr FcPattern, obj: cstring, value: cstring): FcBool
proc FcPatternAddBool*(pattern: ptr FcPattern, obj: cstring, value: FcBool): FcBool
proc FcPatternAddInteger*(pattern: ptr FcPattern, obj: cstring, value: int32): FcBool
{.pop.}
proc FcPatternGetString*(
  pattern: ptr FcPattern, obj: cstring, n: int32, value: ptr ptr FcChar8
): FcResult

proc FcPatternDestroy*(pattern: ptr FcPattern)
proc FcFontList*(
  conf: ptr FcConfig, p: ptr FcPattern, os: ptr FcObjectSet
): ptr FcFontSet

proc FcObjectSetBuild*(first: cstring): ptr FcObjectSet {.varargs.}
proc FcFontMatch*(
  conf: ptr FcConfig, pattern: ptr FcPattern, res: ptr FcResult
): ptr FcPattern

proc FcDefaultSubstitute*(patt: ptr FcPattern)
proc FcConfigSubstitute*(conf: ptr FcConfig, patt: ptr FcPattern, kind: int32): FcBool

proc FcNameParse*(name: ptr FcChar8): ptr FcPattern
{.pop.}

{.pop.}
