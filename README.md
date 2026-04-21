# nitty

Nitty is a fast terminal emulator written in Nim.
It was originally written in ~4 days and has ~1000 lines of code.

It uses its GPU-accelerated renderer by default, but can optionally use the CPU-based renderer (sluggish!) if push comes to shove (the push in this case being `NITTY_RENDERER=sw|hw` :P)

It uses `libvterm` for handling VT output and acting upon it.

![A screenshot of Nitty running htop](screenshots/htop.jpg)
![A screenshot of Nitty running Neovim](screenshots/nvim.jpg)

# Support
You can join [the Discord server](https://discord.gg/q49NSg8eaG) here for help with Nitty, or to follow its development.

# Features
- Runs most terminal apps fine (keyword: **most**)
  * In fact, this README was written entirely in Neovim running inside Nitty!
- Color rendering support
- Config file (`~/.config/nitty/config.toml`)
- Ctrl+Plus and Ctrl+Minus to increase/decrease font size
- Fast GPU renderer and acceptable CPU renderer, though the latter can still use some optimizations.
- Tab completions in shells work

# Roadmap
- [ ] Cursor rendering
- [X] Input improvements (repeat key events, mostly)
- [X] GPU acceleration via NanoVG
- [ ] Scrollback using scroll wheel
- [X] Fractional scaling
- [ ] Packaging for distros

# Config
Here's a basic config for Nitty:

```toml
[appearance]
background = "#5050500A"

[font]
name = "JetBrains Mono"
size = 24.0

[user]
shell = "zsh"
```

# Building
Nitty can be built using [Neo](https://github.com/xTrayambak/neo). After installing Neo, you can run the following command to compile Nitty:
```bash
$ neo install
```
