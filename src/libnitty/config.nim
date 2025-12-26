## Routines to parse and handle the `config.toml` file.
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[os, options, strutils]
import pkg/[chronicles, chroma, parsetoml, pixie, shakar]
import ./[coloring, fonts, types]

logScope:
  topics = "libnitty config file"

type
  AppearanceConfig = object
    background*: string
      ## Background color. May start with hash (#), make sure to strip it out, if found.

  FontConfig = object
    name*: string ## The target font's name.
    size*: float ## The default font size for the terminal.

  UserConfig = object
    shell*: string ## The shell that is to be used. Defaults to `sh`.

  Config* = object
    appearance*: AppearanceConfig
    font*: FontConfig
    user*: UserConfig

const
  AppearanceTabKey = "appearance"
  FontTabKey = "font"
  UserTabKey = "user"

  BackgroundAttrKey = "background"
  NameAttrKey = "name"
  SizeAttrKey = "size"
  ShellAttrKey = "shell"

  ## The default configuration that Nitty uses, if the user's config
  ## either doesn't exist, or is malformed.
  DefaultConfig = Config(
    appearance: AppearanceConfig(background: "5050500A"),
    font: FontConfig(size: 24f),
    user: UserConfig(shell: "sh"),
  )

proc readConfig*(src: string): Option[Config] =
  try:
    let data = parsetoml.parseString(src)

    var config: Config
    if AppearanceTabKey in data:
      let appearanceTable = data[AppearanceTabKey]

      config.appearance.background = appearanceTable[BackgroundAttrKey].getStr(
        default = DefaultConfig.appearance.background
      )

    if FontTabKey in data:
      let fontTable = data[FontTabKey]

      config.font.name =
        fontTable[NameAttrKey].getStr(default = DefaultConfig.font.name)

      config.font.size =
        fontTable[SizeAttrKey].getFloat(default = DefaultConfig.font.size)

    if UserTabKey in data:
      let userTable = data[UserTabKey]

      config.user.shell =
        userTable[ShellAttrKey].getStr(default = DefaultConfig.user.shell)

    return some(ensureMove(config))
  except parsetoml.TomlError as exc:
    error "Failed to parse configuration file! It seems to be malformed.",
      exception = exc.msg, line = exc.location.line, column = exc.location.column
    return none(Config)

proc applyConfig*(terminal: Terminal, config: Config) {.raises: [PixieError].} =
  ## This function applies the user's preferred config inputs
  ## to the terminal.
  ##
  ## **It must NEVER crash the terminal, except in one, rare case (more on that below).**

  let backgroundHex =
    config.appearance.background.strip(leading = true, trailing = false, chars = {'#'})

  template invalidBackgroundColor() =
    warn "Invalid background color value specified. Expected 8-char-long or 6-char-long hexadecimal value. [appearance:background]",
      got = backgroundHex

    {.cast(raises: []).}:
      terminal.backgroundColor =
        bgra(chroma.parseHexAlpha(DefaultConfig.appearance.background).rgba)

  try:
    case backgroundHex.len
    of 8:
      # RRGGBBAA
      terminal.backgroundColor = bgra(chroma.parseHexAlpha(backgroundHex).rgba)
    of 6:
      # RRGGBB
      terminal.backgroundColor = bgra(chroma.parseHex(backgroundHex).rgba)
    else:
      invalidBackgroundColor()
  except chroma.InvalidColor as exc:
    invalidBackgroundColor()

  # Load user-specified font, if specified.
  # A crash here is tolerated.
  if config.font.name.len > 0:
    # HACK: [1] This is the only codepath where a crash is tolerated,
    # simply because it would be stupid to sit silently here.

    let path = findFontPath(config.font.name)
    var finalPath: string
    if !path:
      warn "Cannot find font, degrading to any usable font.", name = config.font.name

      # HACK: [2] If we can't find ANY usable font on the system (not even a non-monospace one), then this system is just... messed up. We can abort because I highly doubt any terminal would even try this hard. Maybe we can implement an internal fallback font in the future, maybe not. A crashed terminal is better than one that silently can't display anything in this case.
      finalPath = &findUsableFont()
    else:
      debug "Using user-specified font", name = config.font.name

      finalPath = &path

    assert(finalPath.len > 0)
    debug "Loading font", path = finalPath
    terminal.font = readFont(ensureMove(finalPath))
  else:
    # HACK: Same as [2]
    terminal.font = readFont(&findUsableFont())

  # Font size
  terminal.font.size = float32(config.font.size)

  # Shell
  terminal.shell = config.user.shell

proc loadConfig*(
    path: Option[string] = none(string)
): Config {.sideEffect, raises: [].} =
  ## This function reads the user's Nitty configuration,
  ## located at `$XDG_CONFIG_HOME/nitty/config.toml` and constructs
  ## the `Config` object using it. If the file does not exist, then
  ## Nitty uses its own default configuration.
  ##
  ## If the user's configuration is malformed or unusable, then Nitty defaults to
  ## its own default configuration. This is to ensure that the user still has a
  ## usable terminal, even after making an oopsie.
  ##
  ## This function is guaranteed to succeed, even if the user's configuration
  ## is in a degraded/unusable state. **It must NEVER crash the terminal.**
  let path =
    if *path:
      &path
    else:
      getConfigDir() / "nitty" / "config.toml"

  if fileExists(path):
    debug "Reading and loading configuration", path = path
    try:
      {.cast(raises: []).}:
        let config = readConfig(readFile(path))

      if !config:
        warn "The user's configuration seems to be malformed, degrading to default config. Check the error above for more info."
      else:
        debug "Parsed user config successfully."
        return &config
    except system.CatchableError as exc:
      error "Failed to read user config. Something is really wrong. Degrading to default configuration.",
        err = exc.msg

  debug "Using default config."
  return DefaultConfig
