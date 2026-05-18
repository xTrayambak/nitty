## Routines to parse and handle the `config.toml` file.
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/[os, options, strutils]
import pkg/[chronicles, chroma, parsetoml, pixie, shakar]
import ./[fonts, types]

logScope:
  topics = "libnitty/config"

type
  AppearanceConfig = object
    background*: string
      ## Background color. May start with hash (#), make sure to strip it out, if found.

  FontConfig = object
    name*: string ## The target font's name.
    size*: float ## The default font size for the terminal.

  UserConfig = object
    shell*: string ## The shell that is to be used. Defaults to `sh`.
    bell*: bool
      ## If the bell escape code is encountered, should Nitty attempt to ring the system bell?

  Config* = object
    appearance*: AppearanceConfig
    font*: FontConfig
    user*: UserConfig

  LayerSurfaceConfig* = object
    layer*: string
    anchors*: seq[string]
    size*: array[2, uint32]
    keyboard_interactivity*: string

  LayerExecConfig* = object
    cmd*: string

  LayerConfig* = object
    surface*: LayerSurfaceConfig
    exec*: LayerExecConfig

const
  AppearanceTabKey = "appearance"
  FontTabKey = "font"
  UserTabKey = "user"

  BackgroundAttrKey = "background"
  NameAttrKey = "name"
  SizeAttrKey = "size"
  ShellAttrKey = "shell"
  BellAttrKey = "bell"

  ## The default configuration that Nitty uses, if the user's config
  ## either doesn't exist, or is malformed.
  DefaultConfig = Config(
    appearance: AppearanceConfig(background: "2222220A"),
    font: FontConfig(size: 24f),
    user: UserConfig(shell: "sh", bell: true),
  )

  SurfaceTabKey = "surface"
  ExecTabKey = "exec"

  LayerAttrKey = "layer"
  AnchorsAttrKey = "anchors"
  LayerSurfaceSizeAttrKey = "size"
  KeyboardInteractivityAttrKey = "keyboard_interactivity"
  CmdAttrKey = "cmd"

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

      if ShellAttrKey in userTable:
        config.user.shell =
          userTable[ShellAttrKey].getStr(default = DefaultConfig.user.shell)

      if BellAttrKey in userTable:
        config.user.bell =
          userTable[BellAttrKey].getBool(default = DefaultConfig.user.bell)

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
        rgba(chroma.parseHexAlpha(DefaultConfig.appearance.background))

  try:
    case backgroundHex.len
    of 8:
      # RRGGBBAA
      terminal.backgroundColor = rgba(chroma.parseHexAlpha(backgroundHex))
    of 6:
      # RRGGBB
      terminal.backgroundColor = rgba(chroma.parseHex(backgroundHex))
    else:
      invalidBackgroundColor()
  except chroma.InvalidColor:
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

  # Bell
  terminal.useBell = config.user.bell

proc readLayerConfig*(src: string): Option[LayerConfig] =
  try:
    let data = parsetoml.parseString(src)

    var config: LayerConfig
    if SurfaceTabKey in data:
      let surfaceTable = data[SurfaceTabKey]

      config.surface.layer = surfaceTable[LayerAttrKey].getStr()
      for i, value in surfaceTable[AnchorsAttrKey].getElems():
        if i > 3:
          raise newException(
            ValueError,
            "Attribute [surface:anchors] cannot have more than four elements!",
          )

        config.surface.anchors &= value.getStr()

      for i, value in surfaceTable[LayerSurfaceSizeAttrKey].getElems():
        if i > 1:
          raise newException(
            ValueError,
            "Attribute [surface:size] cannot have more than two elements [x, y]!",
          )

        config.surface.size[i] = cast[uint32](value.getInt())

      config.surface.keyboard_interactivity =
        surfaceTable[KeyboardInteractivityAttrKey].getStr()

    if ExecTabKey in data:
      let execTable = data[ExecTabKey]

      config.exec.cmd = execTable[CmdAttrKey].getStr()

    return some(ensureMove(config))
  except parsetoml.TomlError as exc:
    error "Failed to parse layer configuration file! It seems to be malformed.",
      exception = exc.msg, line = exc.location.line, column = exc.location.column
    return none(LayerConfig)
  except ValueError as exc:
    error "Failed to parse layer configuration file! It seems to be have a spurious configuration.",
      exception = exc.msg
    return none(LayerConfig)

proc loadLayerConfig*(
    path: Option[string] = none(string), name: string
): Option[LayerConfig] {.sideEffect.} =
  ## This function reads a provided layer widget configuration (`name`).
  ## If `path` is provided, the location of the configuration is assumed to be `{path}/{name}.toml`, otherwise the location is assumed to be `$XDG_CONFIG_HOME/nitty/layers/{name}.toml`
  ## 
  ## This function is not guaranteed to succeed in the event that the configuration is malformed. Its callers will likely abort execution after it reports a failure.
  let path =
    if *path:
      &path / (name & ".toml")
    else:
      getConfigDir() / "nitty" / "layers" / (name & ".toml")

  if not fileExists(path):
    error "Cannot find layer widget configuration!", path = path
    return none(LayerConfig)

  readLayerConfig(readFile(path))

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
