## Logic to forward keyboard input to the VTerm emulator machine
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/tables
import pkg/xkb
import bindings/libvterm
import ./[types]

const SpecialKeysyms = {
  XKB_Key_Return: VTermKey.Enter,
  XKB_Key_Backspace: VTermKey.Backspace,
  XKB_Key_Escape: VTermKey.Escape,
  XKB_Key_Up: VTermKey.Up,
  XKB_Key_Down: VTermKey.Down,
  XKB_Key_Left: VTermKey.Left,
  XKB_Key_Right: VTermKey.Right,
  XKB_Key_Tab: VTermKey.Tab,
  XKB_Key_F1: cast[VTermKey](cast[int32](VTermKey.Function0) + 1'i32),
  XKB_Key_F2: cast[VTermKey](cast[int32](VTermKey.Function0) + 2'i32),
  XKB_Key_F3: cast[VTermKey](cast[int32](VTermKey.Function0) + 3'i32),
  XKB_Key_F4: cast[VTermKey](cast[int32](VTermKey.Function0) + 4'i32),
  XKB_Key_F5: cast[VTermKey](cast[int32](VTermKey.Function0) + 5'i32),
  XKB_Key_F6: cast[VTermKey](cast[int32](VTermKey.Function0) + 6'i32),
  XKB_Key_F7: cast[VTermKey](cast[int32](VTermKey.Function0) + 7'i32),
  XKB_Key_F8: cast[VTermKey](cast[int32](VTermKey.Function0) + 8'i32),
  XKB_Key_F9: cast[VTermKey](cast[int32](VTermKey.Function0) + 9'i32),
  XKB_Key_F10: cast[VTermKey](cast[int32](VTermKey.Function0) + 10'i32),
  XKB_Key_F11: cast[VTermKey](cast[int32](VTermKey.Function0) + 11'i32),
  XKB_Key_F12: cast[VTermKey](cast[int32](VTermKey.Function0) + 12'i32),
}.toTable

proc handleTerminalKeybinds*(
    terminal: Terminal, modifier: VTermModifier, keysym: XkbKeysym
): bool =
  if modifier == VTermModifier.Ctrl and keysym == XKB_Key_Equal:
    # CTRL+PLUS: Increase font size
    terminal.font.size += 0.5f
    terminal.fullDamage()
    return true

  if modifier == VTermModifier.Ctrl and keysym == XKB_Key_Minus:
    # CTRL+MINUS: Decrease font size
    terminal.font.size -= 0.5f
    terminal.fullDamage()
    return true

  false

proc handleKeyInput*(terminal: Terminal, keycode: uint32) =
  # We need to forward the keycode to libvterm.
  let keycode = XkbKeyCode(keycode + 8)
  let keysym = terminal.app.xkbState.getOneSym(keycode)
  let key32 = terminal.app.xkbState.getUtf32(keycode)

  var modifier: VTermModifier
  if terminal.app.xkbState.modNameIsActive(
    XKB_MOD_NAME_SHIFT, XkbStateComponent.ModsEffective
  ) != 0:
    modifier = VTermModifier.Shift

  if terminal.app.xkbState.modNameIsActive(
    XKB_MOD_NAME_ALT, XkbStateComponent.ModsEffective
  ) != 0:
    modifier =
      cast[VTermModifier](cast[uint8](modifier) or cast[uint8](VTermModifier.Alt))

  if terminal.app.xkbState.modNameIsActive(
    XKB_MOD_NAME_CTRL, XkbStateComponent.ModsEffective
  ) != 0:
    modifier =
      cast[VTermModifier](cast[uint8](modifier) or cast[uint8](VTermModifier.Ctrl))

  if handleTerminalKeybinds(terminal, modifier, keysym):
    return

  if int(keysym) in SpecialKeysyms:
    vterm_keyboard_key(terminal.vterm.vt, SpecialKeysyms[int(keysym)], modifier)
  else:
    # Regular symbols (a-Z, 0-9, ~, !, ", ', etc.)
    var buff: array[8, char]
    let n = terminal.app.xkbState.getUtf8(
      keycode, cast[cstring](buff[0].addr), sizeof(buff).csize_t()
    )

    if n != 0:
      if modifier == VTermModifier.Ctrl:
        # TODO: I don't know if this is the right way to do
        # this. Eh, but it works so I don't really care. :P
        vterm_keyboard_unichar(
          terminal.vterm.vt, keysym and 0x1F'u32, VTermModifier.None
        )
        return

      vterm_keyboard_unichar(terminal.vterm.vt, keysym, modifier)
    else:
      discard
