## EGL renderer
##
## The CPU renderer is a-OK for most cases, but it completely dies when running something
## like `sl` or `htop` with a lot of cells.
##
## The GPU renderer simply maintains a map of different renderables, and this makes
## drawing a cell as cheap as creating a quad, which is insanely efficient on GPUs.
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import ../surfer/backend/wayland/bindings/gles2
import pkg/[vmath, pixie]

const
  FragmentShaderSrc = staticRead("hw/frag.glsl")
  VertexShaderSrc = staticRead("hw/vert.glsl")

type ESRenderer* = object
  texture: GLuint
  program: GLuint

  dimensions*: IVec2

proc compileShader(typ: GLenum, source: string): GLuint =
  let shader = glCreateShader(typ)
  let source = cstring(source)
  glShaderSource(shader, 1, cast[ptr ptr GlChar](source.addr), nil)
  glCompileShader(shader)

  var compiled: GLint
  glGetShaderIv(shader, GL_COMPILE_STATUS, compiled.addr)

  if compiled != 1:
    var length: GLint
    glGetShaderIv(shader, GL_INFO_LOG_LENGTH, length.addr)

    var log = newString(length)
    glGetShaderInfoLog(shader, length, nil, log[0].addr)

    echo "Can't compile: " & move(log)

    glDeleteShader(shader)
    assert off

  shader

proc initialize*(renderer: var ESRenderer) =
  renderer.program = glCreateProgram()

  glAttachShader(renderer.program, compileShader(GL_FRAGMENT_SHADER, FragmentShaderSrc))
  glAttachShader(renderer.program, compileShader(GL_VERTEX_SHADER, VertexShaderSrc))

  glLinkProgram(renderer.program)

  glViewport(0, 0, renderer.dimensions.x, renderer.dimensions.y)

proc upload*(renderer: var ESRenderer, buff: Image) =
  glGenTextures(1, renderer.texture.addr)
  glBindTexture(GL_TEXTURE_2D, renderer.texture)

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    buff.width.GLsizei,
    buff.height.GLsizei,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    buff.data[0].addr,
  )

proc render*(renderer: var ESRenderer) =
  glUseProgram(renderer.program)

  var vertices = [-1f, -1f, 0f, 0f, 1f, -1f, 1f, 0f, -1f, 1f, 0f, 1f, 1f, 1f, 1f, 1f]

  let
    posLoc = glGetAttribLocation(renderer.program, cast[ptr GlChar](cstring "aPos"))
    uvLoc = glGetAttribLocation(renderer.program, cast[ptr GlChar](cstring "aUV"))
    texLoc = glGetAttribLocation(renderer.program, cast[ptr GlChar](cstring "uTexture"))

  glActiveTexture(GL_TEXTURE0)
  glBindTexture(GL_TEXTURE_2D, renderer.texture)
  glUniform1i(texLoc, 0)

  glEnableVertexAttribArray(posLoc.Gluint)
  glEnableVertexAttribArray(uvLoc.Gluint)

  glVertexAttribPointer(
    posLoc.Gluint,
    2,
    cGL_FLOAT,
    GL_FALSE.GlBoolean,
    4 * sizeof(vertices),
    vertices[0].addr,
  )
  glVertexAttribPointer(
    uvLoc.GlUint,
    2,
    cGL_FLOAT,
    GL_FALSE.GlBoolean,
    4 * sizeof(vertices),
    vertices[2].addr,
  )
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
