## Bindings to the simdutf C API.
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)

when not defined(NeoPkgVersion):
  import std/strutils

  {.passC: strip(gorge("pkg-config --cflags simdutf")).}
  {.passL: strip(gorge("pkg-config --libs simdutf")).}

{.push header: "<simdutf_c.h>".}

type
  ErrorCode* {.importc: "enum simdutf_error_code", pure.} = enum
    Success = 0
    HeaderBits
    TooShort
    TooLong
    Overlong
    TooLarge
    Surrogate
    InvalidBase64Character
    Base64InputRemainder
    Base64ExtraBits
    OutputBufferTooSmall
    Other

  Output* {.importc: "struct simdutf_result".} = object
    error*: ErrorCode
    count*: uint64

proc validateUtf8*(
  buf: ptr uint8 | ptr char, size: uint64
): bool {.importc: "simdutf_validate_utf8".}

{.pop.}
