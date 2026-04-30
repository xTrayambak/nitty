## Parser for escape sequences
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import ./[types]

func handleStrFragment*()

func eat*(parser: var Parser, input: ParserInput) =
  var pos = 0'u64
  var strStart = 0'u64

  let buffer = toOpenArray(cast[ptr UncheckedArray[byte]](input.data))

  template isStringState() =
    cast[uint8](parser.state) > cast[uint8](ParserState.OSCCommand)

  while pos < input.size:
    let c = buffer[pos]

    case c
    of 0'u8, 0x7F'u8:
      # NUL / DEL
      if isStringState():
        handleStrFragment(
          parser, toOpenArrayByte(buffer, pos.int, buffer.len), false, Terminator.ST
        )

      continue
    of 0x18'u8, 0x1a'u8:
      # CAN / SUB
      parser.inEscape = false
      parser.state = ParserState.Normal
      strStart = 0'u64
    of 0x1b'u8:
      # ESC
      # parser.intermedlen = 0
      if isStringState():
        parser.state = ParserState.Normal

      parser.inEscape = true
    else:
      if (c == 0x07'u8 and isStringState()):
        # BEL, can stand for ST in OSC or DCS state
        discard
      elif c < 0x20'u8:
        # Other C0
        if parser.state == ParserState.SOS:
          continue # All other C0s permitted in SOS 

    inc pos
