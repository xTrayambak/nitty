## libvterm bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)

type
  ConstCStr* {.importc: "const char *".} = cstring

  VTermColorRGB {.union.} = object
    `type`*: uint8
    r*, g*, b*: uint8

  VTermColorIndexed {.union.} = object
    `type`*: uint8
    idx*: uint8

{.push header: "<vterm.h>".}
type
  VTerm* {.importc: "struct $1".} = object
  VTermState* {.importc: "struct $1".} = object
  VTermScreen* {.importc: "struct $1".} = object
  VTermRect* {.importc.} = object
    start_row*: int32
    end_row*: int32
    start_col*: int32
    end_col*: int32

  VTermModifier* {.importc: "VTermModifier", size: sizeof(uint8), pure.} = enum
    None = 0x00
    Shift = 0x01
    Alt = 0x02
    Ctrl = 0x03
    AllMods = 0x07

  VTermKey* {.importc, pure.} = enum
    None
    Enter
    Tab
    Backspace
    Escape
    Up
    Down
    Left
    Right
    Insert
    Delete
    Home
    End
    PageUp
    PageDown
    Function0 = 256
    FunctionMax = 511
    Keypad0
    Keypad1
    Keypad2
    Keypad3
    Keypad4
    Keypad5
    Keypad6
    Keypad7
    Keypad8
    Keypad9
    KeypadMult
    KeypadPlus
    KeypadComma
    KeypadMinus
    KeypadPeriod
    KeypadDivide
    KeypadEnter
    KeypadEqual
    KeyMax

  VTermStringFragment* {.importc.} = object
    str*: cstring
    len*: uint64
    initial*, final*: bool

  VTermPos* {.importc: "$1".} = object
    row*, col*: int32

  VTermProp* {.importc: "$1", pure.} = enum
    CursorVisible = 1
    CursorBlink
    AltScreen
    Title
    IconName
    Reverse
    CursorShape
    Mouse
    FocusReport
    NProps

  VTermColor* {.importc, union.} = object
    `type`*: uint8
    rgb*: VTermColorRGB
    indexed*: VTermColorIndexed

  VTermValue* {.importc: "$1".} = object
    boolean*: bool
    number*: int32
    string*: VTermStringFragment
    color*: VTermColor

  VTermScreenCellAttrs* {.importc: "$1".} = object
    bold*, underline*, italic*, blink*, reverse*, conceal*, strike*, font*, dwl*, dhl*,
      small*, baseline*: uint8

  VTermScreenCell* {.importc: "$1".} = object
    chars*: array[6, uint32]
    width*: uint8
    attrs*: VTermScreenCellAttrs
    fg*, bg*: VTermColor

  ConstVTermScreenCell* {.importc: "const VTermScreenCell".} = object
    chars*: array[6, uint32]
    width*: uint8
    attrs*: VTermScreenCellAttrs
    fg*, bg*: VTermColor

  VTermParserCallbacks* {.importc: "$1".} = object
    text*: proc(bytes: cstring, length: uint64, user: pointer): int32 {.cdecl.}
    control*: proc(control: char, user: pointer): int32 {.cdecl.}
    escape*: proc(bytes: cstring, length: uint64, user: pointer): int32 {.cdecl.}
    csi*: proc(
      leader: cstring,
      args: ptr UncheckedArray[uint64],
      argcount: int32,
      intermed: cstring,
      command: char,
      user: pointer,
    ): int32 {.cdecl.}
    osc*: proc(cmd: int32, frag: VTermStringFragment, user: pointer): int32 {.cdecl.}
    dcs*: proc(
      cmd: cstring, commandLen: uint64, frag: VTermStringFragment, user: pointer
    ): int32 {.cdecl.}
    apc*: proc(frag: VTermStringFragment, user: pointer): int32 {.cdecl.}
    pm*: proc(frag: VTermStringFragment, user: pointer): int32 {.cdecl.}
    sos*: proc(frag: VTermStringFragment, user: pointer): int32 {.cdecl.}
    resize*: proc(rows, cols: int32, user: pointer): int32 {.cdecl.}

  VTermScreenCallbacks* {.importc.} = object
    damage*: proc(rect: VTermRect, user: pointer): int32 {.cdecl.}
    moverect*: proc(dest: VTermRect, src: VTermRect, user: pointer): int32 {.cdecl.}
    movecursor*: proc(
      pos: VTermPos, oldpos: VTermPos, visible: int32, user: pointer
    ): int32 {.cdecl.}
    settermprop*:
      proc(prop: VTermProp, val: ptr VTermValue, user: pointer): int32 {.cdecl.}
    bell*: proc(user: pointer): int32 {.cdecl.}
    resize*: proc(rows: int32, cols: int32, user: pointer): int32 {.cdecl.}
    sb_pushline*:
      proc(cols: int32, cells: ptr ConstVTermScreenCell, user: pointer): int32 {.cdecl.}
    sb_popline*:
      proc(cols: int32, cells: ptr VTermScreenCell, user: pointer): int32 {.cdecl.}
    sb_clear*: proc(user: pointer): int32 {.cdecl.}

  VTermDamageSize* {.importc: "$1", pure.} = enum
    Cell ## Every cell
    Row ## Entire rows
    DamageScreen ## Entire screen
    DamageScroll ## Entire screen + scrollrect
    NDamages

  VTermColorType* {.importc, pure.} = enum
    RGB = 0x00
    Indexed = 0x01
    DefaultFG = 0x02
    DefaultBG = 0x04
    DefaultMask = 0x06

{.push importc.}
proc vterm_new*(rows, cols: int32): ptr VTerm
proc vterm_free*(vt: ptr VTerm)
proc vterm_set_utf8*(vt: ptr VTerm, state: bool)

proc vterm_obtain_state*(vt: ptr VTerm): ptr VTermState
proc vterm_obtain_screen*(vt: ptr VTerm): ptr VTermScreen
proc vterm_state_free*(vst: ptr VTermState)
proc vterm_screen_free*(vsn: ptr VTermScreen)

proc vterm_input_write*(vt: ptr VTerm, bytes: ptr char, len: uint64): uint64

proc vterm_keyboard_unichar*(vt: ptr VTerm, c: uint32, modifier: VTermModifier)
proc vterm_keyboard_key*(vt: ptr VTerm, key: VTermKey, modifier: VTermModifier)
proc vterm_keyboard_start_paste*(vt: ptr VTerm)
proc vterm_keyboard_end_paste*(vt: ptr VTerm)

proc vterm_mouse_move*(vt: ptr VTerm, row, col: int32, modifier: VTermModifier)
proc vterm_mouse_button*(
  vt: ptr VTerm, button: int32, pressed: bool, modifier: VTermModifier
)

proc vterm_parser_set_callbacks*(
  vt: ptr VTerm, callbacks: ptr VTermParserCallbacks, user: pointer
)

proc vterm_screen_flush_damage*(vts: ptr VTermScreen)
proc vterm_screen_set_damage_merge*(vts: ptr VTermScreen, size: VTermDamageSize)
proc vterm_screen_reset*(vts: ptr VTermScreen, hard: int32)

proc vterm_screen_get_chars*(
  vts: ptr VTermScreen,
  chars: ptr UncheckedArray[uint32],
  length: uint64,
  rect: VTermRect,
): uint64

proc vterm_screen_get_cell*(
  screen: ptr VTermScreen, pos: VTermPos, cell: ptr VTermScreenCell
): int32

proc vterm_set_size*(vt: ptr VTerm, rows, cols: int32)

proc vterm_screen_get_text*(
  vts: ptr VTermScreen, str: ptr char, length: uint64, rect: VTermRect
): uint64

proc vterm_screen_set_callbacks*(
  screen: ptr VTermScreen, callbacks: ptr VTermScreenCallbacks, user: pointer
)

proc vterm_output_set_callback*(
  vt: ptr VTerm,
  fn: proc(s: ConstCStr, size: uint64, user: pointer) {.cdecl.},
  user: pointer,
)

{.pop.}

{.pop.}

# ts pmo
func r*(c: VTermColor): uint8 =
  {.emit: "`result` = `c`.rgb.red;".}

func g*(c: VTermColor): uint8 =
  {.emit: "`result` = `c`.rgb.green;".}

func b*(c: VTermColor): uint8 =
  {.emit: "`result` = `c`.rgb.blue;".}

func idx*(c: VTermColor): uint8 =
  {.emit: "`result` = `c`.indexed.idx;".}

func isRGB*(col: VTermColor): bool =
  (cast[uint8](col.`type`) and 0x01'u8) == cast[uint8](VTermColorType.RGB)

func isIndexed*(col: VTermColor): bool =
  (cast[uint8](col.`type`) and 0x01'u8) == cast[uint8](VTermColorType.Indexed)

func isDefaultFG*(col: VTermColor): bool =
  cast[bool]((cast[uint8](col.`type`) and cast[uint8](VTermColorType.DefaultFG)))

func isDefaultBG*(col: VTermColor): bool =
  cast[bool]((cast[uint8](col.`type`) and cast[uint8](VTermColorType.DefaultBG)))

func `$`*(frag: VTermStringFragment): string =
  var buff = newString(frag.len)
  if frag.len > 0:
    copyMem(buff[0].addr, frag.str[0].addr, frag.len)

  ensureMove(buff)
