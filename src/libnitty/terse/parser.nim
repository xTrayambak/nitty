## Parser for escape sequences
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import ./[types]

func handleStrFragment*(
    parser: var Parser, str: openArray[byte], terminator: Terminator
) =
  debugEcho "handleStrFragment " & $parser.state

func isIntermed(c: uint8): bool {.inline, raises: [].} =
  c >= 0x20'u8 and c <= 0x2f'u8

func handleCSI(parser: var Parser, cmd: char) =
  debugEcho "Handle CSI '" & cmd & '\''

func handleEscape(parser: var Parser, cmd: char) =
  debugEcho "Handle escape '" & cmd & '\''

func handleText(parser: var Parser, str: openArray[byte]): uint64 =
  let eaten = cast[uint64](str.len)

  eaten - 1'u64

func eat*(parser: var Parser, input: ParserInput) =
  var pos = 0'u64
  var strStart = 0'u64
  var c1Allowed = false

  let buffer = cast[ptr UncheckedArray[byte]](input.data)

  template isStringState(): bool =
    cast[uint8](parser.state) > cast[uint8](ParserState.OSCCommand)

  while pos < input.size:
    var c = buffer[pos]
    inc pos

    case c
    of 0'u8, 0x7F'u8:
      # NUL / DEL
      if isStringState():
        handleStrFragment(
          parser, toOpenArray(buffer, pos.int, input.size.int), Terminator.ST
        )

      continue
    of 0x18'u8, 0x1a'u8:
      # CAN / SUB
      parser.inEscape = false
      parser.state = ParserState.Normal
      strStart = 0'u64
    of 0x1b'u8:
      # ESC
      parser.intermed.len = 0
      if isStringState():
        parser.state = ParserState.Normal

      parser.inEscape = true
      continue
    else:
      if (c == 0x07'u8 and isStringState()):
        # BEL, can stand for ST in OSC or DCS state
        discard
      elif c < 0x20'u8:
        # Other C0
        if parser.state == ParserState.SOS:
          continue # All other C0s permitted in SOS 

    var strLen = input.size - pos
    if parser.inEscape:
      # Hoist an ESC letter into a C1 if we're not in a string mode
      # Always accept ESC \ == ST even in string mode
      if parser.intermed.len < 1 and c >= 0x40'u8 and c < 0x60'u8 and
          (not isStringState() or c == 0x5c'u8):
        c += 0x40
        c1Allowed = true

        if strLen != 0:
          dec strLen

        parser.inEscape = false
      else:
        parser.state = ParserState.Normal

    case parser.state
    of ParserState.CSILeader:
      # Extract leader bytes 0x3c to 0x3f
      if c >= 0x3c and c <= 0x3f:
        if cast[uint64](parser.pool.csi.leader.len) < CSILeaderMax - 1:
          parser.pool.csi.leader.data[parser.pool.csi.leader.len] = cast[char](c)
          inc parser.pool.csi.leader.len

        break
    of ParserState.CSIArgs:
      # Numerical value of argument
      if cast[char](c) >= '0' and cast[char](c) <= '9':
        if parser.pool.csi.args.data[parser.pool.csi.args.len] == CSIArgMissing:
          parser.pool.csi.args.data[parser.pool.csi.args.len] = 0'u32

        parser.pool.csi.args.data[parser.pool.csi.args.len] *=
          10'u32 + cast[uint32](c.uint8 - '0'.uint8)

      if cast[char](c) == ':':
        parser.pool.csi.args.data[parser.pool.csi.args.len] =
          parser.pool.csi.args.data[parser.pool.csi.args.len] or CSIArgFlagMore
        c = cast[uint8](';')

      if cast[char](c) == ';':
        inc parser.pool.csi.args.len
        parser.pool.csi.args.data[parser.pool.csi.args.len] =
          parser.pool.csi.args.data[parser.pool.csi.args.len] or CSIArgMissing
        break

      inc parser.pool.csi.args.len
      parser.intermed.len = 0
      parser.state = ParserState.CSIIntermed
    of ParserState.CSIIntermed:
      if isIntermed(c):
        if parser.intermed.len < IntermedMax - 1:
          inc parser.intermed.len
          parser.intermed.data[parser.intermed.len] = cast[char](c)

        break
      elif c == 0x1B:
        # ESC in CSI cancels
        discard
      elif c >= 0x40 and c <= 0x7E:
        parser.intermed.data[parser.intermed.len] = '\0'
        handleCSI(parser, cast[char](c))

      parser.state = ParserState.Normal
      break
    of ParserState.Normal:
      if parser.inEscape:
        if isIntermed(c):
          if parser.intermed.len < IntermedMax - 1:
            inc parser.intermed.len
            parser.intermed.data[parser.intermed.len] = cast[char](c)
        elif c >= 0x30 and c < 0x7f:
          handleEscape(parser, cast[char](c))
          parser.inEscape = false
          parser.state = ParserState.Normal

        break

      if c1Allowed and c > 0x80 and c < 0xa0:
        discard "TODO: Handle DCS/SOS/CSI/OSC/PM/APC"
      else:
        var eaten = 0'u64
        eaten = handleText(
          parser, toOpenArray(buffer, cast[int64](pos), cast[int64](input.size))
        )

        if eaten == 0'u64:
          inc eaten

        pos += (eaten - 1'u64)
    else:
      debugecho "Unhandled " & $parser.state
