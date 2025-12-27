## *gles* - Nim bindings for OpenGL ES, the embedded 3D graphics library.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.
##
## License:
## The MIT License (MIT)
## 
## Copyright (c) 2015 nimio.us
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

type
  GlByte* = cschar
  GlClampf* = cfloat
  GlFixed* = cint
  GlShort* = cshort
  GlUshort* = cushort
  GlVoid* = pointer
  GlSync* = pointer
  GlInt64* = clonglong
  GlUint64* = culonglong
  GlEnum* = cuint
  GlUint* = cuint
  GlChar* = char
  GlFloat* = cfloat
  GlSizeiptr* = clong
  GlIntptr* = clong
  GlBitfield* = cuint
  GlInt* = cint
  GlBoolean* = cuchar
  GlSizei* = cint
  GlUbyte* = cuchar

const
  GL_DEPTH_BUFFER_BIT* = 0x00000100
  GL_STENCIL_BUFFER_BIT* = 0x00000400
  GL_COLOR_BUFFER_BIT* = 0x00004000
  GL_FALSE* = 0
  GL_TRUE* = 1
  GL_POINTS* = 0x00000000
  GL_LINES* = 0x00000001
  GL_LINE_LOOP* = 0x00000002
  GL_LINE_STRIP* = 0x00000003
  GL_TRIANGLES* = 0x00000004
  GL_TRIANGLE_STRIP* = 0x00000005
  GL_TRIANGLE_FAN* = 0x00000006
  GL_ZERO* = 0
  GL_ONE* = 1
  GL_SRC_COLOR* = 0x00000300
  GL_ONE_MINUS_SRC_COLOR* = 0x00000301
  GL_SRC_ALPHA* = 0x00000302
  GL_ONE_MINUS_SRC_ALPHA* = 0x00000303
  GL_DST_ALPHA* = 0x00000304
  GL_ONE_MINUS_DST_ALPHA* = 0x00000305
  GL_DST_COLOR* = 0x00000306
  GL_ONE_MINUS_DST_COLOR* = 0x00000307
  GL_SRC_ALPHA_SATURATE* = 0x00000308
  GL_FUNC_ADD* = 0x00008006
  GL_BLEND_EQUATION* = 0x00008009
  GL_BLEND_EQUATION_RGB* = 0x00008009
  GL_BLEND_EQUATION_ALPHA* = 0x0000883D
  GL_FUNC_SUBTRACT* = 0x0000800A
  GL_FUNC_REVERSE_SUBTRACT* = 0x0000800B
  GL_BLEND_DST_RGB* = 0x000080C8
  GL_BLEND_SRC_RGB* = 0x000080C9
  GL_BLEND_DST_ALPHA* = 0x000080CA
  GL_BLEND_SRC_ALPHA* = 0x000080CB
  GL_CONSTANT_COLOR* = 0x00008001
  GL_ONE_MINUS_CONSTANT_COLOR* = 0x00008002
  GL_CONSTANT_ALPHA* = 0x00008003
  GL_ONE_MINUS_CONSTANT_ALPHA* = 0x00008004
  GL_BLEND_COLOR* = 0x00008005
  GL_ARRAY_BUFFER* = 0x00008892
  GL_ELEMENT_ARRAY_BUFFER* = 0x00008893
  GL_ARRAY_BUFFER_BINDING* = 0x00008894
  GL_ELEMENT_ARRAY_BUFFER_BINDING* = 0x00008895
  GL_STREAM_DRAW* = 0x000088E0
  GL_STATIC_DRAW* = 0x000088E4
  GL_DYNAMIC_DRAW* = 0x000088E8
  GL_BUFFER_SIZE* = 0x00008764
  GL_BUFFER_USAGE* = 0x00008765
  GL_CURRENT_VERTEX_ATTRIB* = 0x00008626
  GL_FRONT* = 0x00000404
  GL_BACK* = 0x00000405
  GL_FRONT_AND_BACK* = 0x00000408
  GL_TEXTURE_2D* = 0x00000DE1
  GL_CULL_FACE* = 0x00000B44
  GL_BLEND* = 0x00000BE2
  GL_DITHER* = 0x00000BD0
  GL_STENCIL_TEST* = 0x00000B90
  GL_DEPTH_TEST* = 0x00000B71
  GL_SCISSOR_TEST* = 0x00000C11
  GL_POLYGON_OFFSET_FILL* = 0x00008037
  GL_SAMPLE_ALPHA_TO_COVERAGE* = 0x0000809E
  GL_SAMPLE_COVERAGE* = 0x000080A0
  GL_NO_ERROR* = 0
  GL_INVALID_ENUM* = 0x00000500
  GL_INVALID_VALUE* = 0x00000501
  GL_INVALID_OPERATION* = 0x00000502
  GL_OUT_OF_MEMORY* = 0x00000505
  GL_CW* = 0x00000900
  GL_CCW* = 0x00000901
  GL_LINE_WIDTH* = 0x00000B21
  GL_ALIASED_POINT_SIZE_RANGE* = 0x0000846D
  GL_ALIASED_LINE_WIDTH_RANGE* = 0x0000846E
  GL_CULL_FACE_MODE* = 0x00000B45
  GL_FRONT_FACE* = 0x00000B46
  GL_DEPTH_RANGE* = 0x00000B70
  GL_DEPTH_WRITEMASK* = 0x00000B72
  GL_DEPTH_CLEAR_VALUE* = 0x00000B73
  GL_DEPTH_FUNC* = 0x00000B74
  GL_STENCIL_CLEAR_VALUE* = 0x00000B91
  GL_STENCIL_FUNC* = 0x00000B92
  GL_STENCIL_FAIL* = 0x00000B94
  GL_STENCIL_PASS_DEPTH_FAIL* = 0x00000B95
  GL_STENCIL_PASS_DEPTH_PASS* = 0x00000B96
  GL_STENCIL_REF* = 0x00000B97
  GL_STENCIL_VALUE_MASK* = 0x00000B93
  GL_STENCIL_WRITEMASK* = 0x00000B98
  GL_STENCIL_BACK_FUNC* = 0x00008800
  GL_STENCIL_BACK_FAIL* = 0x00008801
  GL_STENCIL_BACK_PASS_DEPTH_FAIL* = 0x00008802
  GL_STENCIL_BACK_PASS_DEPTH_PASS* = 0x00008803
  GL_STENCIL_BACK_REF* = 0x00008CA3
  GL_STENCIL_BACK_VALUE_MASK* = 0x00008CA4
  GL_STENCIL_BACK_WRITEMASK* = 0x00008CA5
  GL_VIEWPORT* = 0x00000BA2
  GL_SCISSOR_BOX* = 0x00000C10
  GL_COLOR_CLEAR_VALUE* = 0x00000C22
  GL_COLOR_WRITEMASK* = 0x00000C23
  GL_UNPACK_ALIGNMENT* = 0x00000CF5
  GL_PACK_ALIGNMENT* = 0x00000D05
  GL_MAX_TEXTURE_SIZE* = 0x00000D33
  GL_MAX_VIEWPORT_DIMS* = 0x00000D3A
  GL_SUBPIXEL_BITS* = 0x00000D50
  GL_RED_BITS* = 0x00000D52
  GL_GREEN_BITS* = 0x00000D53
  GL_BLUE_BITS* = 0x00000D54
  GL_ALPHA_BITS* = 0x00000D55
  GL_DEPTH_BITS* = 0x00000D56
  GL_STENCIL_BITS* = 0x00000D57
  GL_POLYGON_OFFSET_UNITS* = 0x00002A00
  GL_POLYGON_OFFSET_FACTOR* = 0x00008038
  GL_TEXTURE_BINDING_2D* = 0x00008069
  GL_SAMPLE_BUFFERS* = 0x000080A8
  GL_SAMPLES* = 0x000080A9
  GL_SAMPLE_COVERAGE_VALUE* = 0x000080AA
  GL_SAMPLE_COVERAGE_INVERT* = 0x000080AB
  GL_NUM_COMPRESSED_TEXTURE_FORMATS* = 0x000086A2
  GL_COMPRESSED_TEXTURE_FORMATS* = 0x000086A3
  GL_DONT_CARE* = 0x00001100
  GL_FASTEST* = 0x00001101
  GL_NICEST* = 0x00001102
  GL_GENERATE_MIPMAP_HINT* = 0x00008192
  cGL_BYTE* = 0x00001400
  GL_UNSIGNED_BYTE* = 0x00001401
  cGL_SHORT* = 0x00001402
  GL_UNSIGNED_SHORT* = 0x00001403
  cGL_INT* = 0x00001404
  GL_UNSIGNED_INT* = 0x00001405
  cGL_FLOAT* = 0x00001406
  cGL_FIXED* = 0x0000140C
  GL_DEPTH_COMPONENT* = 0x00001902
  GL_ALPHA* = 0x00001906
  GL_RGB* = 0x00001907
  GL_RGBA* = 0x00001908
  GL_LUMINANCE* = 0x00001909
  GL_LUMINANCE_ALPHA* = 0x0000190A
  GL_UNSIGNED_SHORT_4_4_4_4* = 0x00008033
  GL_UNSIGNED_SHORT_5_5_5_1* = 0x00008034
  GL_UNSIGNED_SHORT_5_6_5* = 0x00008363
  GL_FRAGMENT_SHADER* = 0x00008B30
  GL_VERTEX_SHADER* = 0x00008B31
  GL_MAX_VERTEX_ATTRIBS* = 0x00008869
  GL_MAX_VERTEX_UNIFORM_VECTORS* = 0x00008DFB
  GL_MAX_VARYING_VECTORS* = 0x00008DFC
  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS* = 0x00008B4D
  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS* = 0x00008B4C
  GL_MAX_TEXTURE_IMAGE_UNITS* = 0x00008872
  GL_MAX_FRAGMENT_UNIFORM_VECTORS* = 0x00008DFD
  GL_SHADER_TYPE* = 0x00008B4F
  GL_DELETE_STATUS* = 0x00008B80
  GL_LINK_STATUS* = 0x00008B82
  GL_VALIDATE_STATUS* = 0x00008B83
  GL_ATTACHED_SHADERS* = 0x00008B85
  GL_ACTIVE_UNIFORMS* = 0x00008B86
  GL_ACTIVE_UNIFORM_MAX_LENGTH* = 0x00008B87
  GL_ACTIVE_ATTRIBUTES* = 0x00008B89
  GL_ACTIVE_ATTRIBUTE_MAX_LENGTH* = 0x00008B8A
  GL_SHADING_LANGUAGE_VERSION* = 0x00008B8C
  GL_CURRENT_PROGRAM* = 0x00008B8D
  GL_NEVER* = 0x00000200
  GL_LESS* = 0x00000201
  GL_EQUAL* = 0x00000202
  GL_LEQUAL* = 0x00000203
  GL_GREATER* = 0x00000204
  GL_NOTEQUAL* = 0x00000205
  GL_GEQUAL* = 0x00000206
  GL_ALWAYS* = 0x00000207
  GL_KEEP* = 0x00001E00
  GL_REPLACE* = 0x00001E01
  GL_INCR* = 0x00001E02
  GL_DECR* = 0x00001E03
  GL_INVERT* = 0x0000150A
  GL_INCR_WRAP* = 0x00008507
  GL_DECR_WRAP* = 0x00008508
  GL_VENDOR* = 0x00001F00
  GL_RENDERER* = 0x00001F01
  GL_VERSION* = 0x00001F02
  GL_EXTENSIONS* = 0x00001F03
  GL_NEAREST* = 0x00002600
  GL_LINEAR* = 0x00002601
  GL_NEAREST_MIPMAP_NEAREST* = 0x00002700
  GL_LINEAR_MIPMAP_NEAREST* = 0x00002701
  GL_NEAREST_MIPMAP_LINEAR* = 0x00002702
  GL_LINEAR_MIPMAP_LINEAR* = 0x00002703
  GL_TEXTURE_MAG_FILTER* = 0x00002800
  GL_TEXTURE_MIN_FILTER* = 0x00002801
  GL_TEXTURE_WRAP_S* = 0x00002802
  GL_TEXTURE_WRAP_T* = 0x00002803
  GL_TEXTURE* = 0x00001702
  GL_TEXTURE_CUBE_MAP* = 0x00008513
  GL_TEXTURE_BINDING_CUBE_MAP* = 0x00008514
  GL_TEXTURE_CUBE_MAP_POSITIVE_X* = 0x00008515
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X* = 0x00008516
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y* = 0x00008517
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y* = 0x00008518
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z* = 0x00008519
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z* = 0x0000851A
  GL_MAX_CUBE_MAP_TEXTURE_SIZE* = 0x0000851C
  GL_TEXTURE0* = 0x000084C0
  GL_TEXTURE1* = 0x000084C1
  GL_TEXTURE2* = 0x000084C2
  GL_TEXTURE3* = 0x000084C3
  GL_TEXTURE4* = 0x000084C4
  GL_TEXTURE5* = 0x000084C5
  GL_TEXTURE6* = 0x000084C6
  GL_TEXTURE7* = 0x000084C7
  GL_TEXTURE8* = 0x000084C8
  GL_TEXTURE9* = 0x000084C9
  GL_TEXTURE10* = 0x000084CA
  GL_TEXTURE11* = 0x000084CB
  GL_TEXTURE12* = 0x000084CC
  GL_TEXTURE13* = 0x000084CD
  GL_TEXTURE14* = 0x000084CE
  GL_TEXTURE15* = 0x000084CF
  GL_TEXTURE16* = 0x000084D0
  GL_TEXTURE17* = 0x000084D1
  GL_TEXTURE18* = 0x000084D2
  GL_TEXTURE19* = 0x000084D3
  GL_TEXTURE20* = 0x000084D4
  GL_TEXTURE21* = 0x000084D5
  GL_TEXTURE22* = 0x000084D6
  GL_TEXTURE23* = 0x000084D7
  GL_TEXTURE24* = 0x000084D8
  GL_TEXTURE25* = 0x000084D9
  GL_TEXTURE26* = 0x000084DA
  GL_TEXTURE27* = 0x000084DB
  GL_TEXTURE28* = 0x000084DC
  GL_TEXTURE29* = 0x000084DD
  GL_TEXTURE30* = 0x000084DE
  GL_TEXTURE31* = 0x000084DF
  GL_ACTIVE_TEXTURE* = 0x000084E0
  GL_REPEAT* = 0x00002901
  GL_CLAMP_TO_EDGE* = 0x0000812F
  GL_MIRRORED_REPEAT* = 0x00008370
  cGL_FLOAT_VEC2* = 0x00008B50
  cGL_FLOAT_VEC3* = 0x00008B51
  cGL_FLOAT_VEC4* = 0x00008B52
  cGL_INT_VEC2* = 0x00008B53
  cGL_INT_VEC3* = 0x00008B54
  cGL_INT_VEC4* = 0x00008B55
  GL_BOOL* = 0x00008B56
  GL_BOOL_VEC2* = 0x00008B57
  GL_BOOL_VEC3* = 0x00008B58
  GL_BOOL_VEC4* = 0x00008B59
  cGL_FLOAT_MAT2* = 0x00008B5A
  cGL_FLOAT_MAT3* = 0x00008B5B
  cGL_FLOAT_MAT4* = 0x00008B5C
  GL_SAMPLER_2D* = 0x00008B5E
  GL_SAMPLER_CUBE* = 0x00008B60
  GL_VERTEX_ATTRIB_ARRAY_ENABLED* = 0x00008622
  GL_VERTEX_ATTRIB_ARRAY_SIZE* = 0x00008623
  GL_VERTEX_ATTRIB_ARRAY_STRIDE* = 0x00008624
  GL_VERTEX_ATTRIB_ARRAY_TYPE* = 0x00008625
  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED* = 0x0000886A
  GL_VERTEX_ATTRIB_ARRAY_POINTER* = 0x00008645
  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING* = 0x0000889F
  GL_IMPLEMENTATION_COLOR_READ_TYPE* = 0x00008B9A
  GL_IMPLEMENTATION_COLOR_READ_FORMAT* = 0x00008B9B
  GL_COMPILE_STATUS* = 0x00008B81
  GL_INFO_LOG_LENGTH* = 0x00008B84
  GL_SHADER_SOURCE_LENGTH* = 0x00008B88
  GL_SHADER_COMPILER* = 0x00008DFA
  GL_SHADER_BINARY_FORMATS* = 0x00008DF8
  GL_NUM_SHADER_BINARY_FORMATS* = 0x00008DF9
  GL_LOW_FLOAT* = 0x00008DF0
  GL_MEDIUM_FLOAT* = 0x00008DF1
  GL_HIGH_FLOAT* = 0x00008DF2
  GL_LOW_INT* = 0x00008DF3
  GL_MEDIUM_INT* = 0x00008DF4
  GL_HIGH_INT* = 0x00008DF5
  GL_FRAMEBUFFER* = 0x00008D40
  GL_RENDERBUFFER* = 0x00008D41
  GL_RGBA4* = 0x00008056
  GL_RGB5_A1* = 0x00008057
  GL_RGB565* = 0x00008D62
  GL_DEPTH_COMPONENT16* = 0x000081A5
  GL_STENCIL_INDEX8* = 0x00008D48
  GL_RENDERBUFFER_WIDTH* = 0x00008D42
  GL_RENDERBUFFER_HEIGHT* = 0x00008D43
  GL_RENDERBUFFER_INTERNAL_FORMAT* = 0x00008D44
  GL_RENDERBUFFER_RED_SIZE* = 0x00008D50
  GL_RENDERBUFFER_GREEN_SIZE* = 0x00008D51
  GL_RENDERBUFFER_BLUE_SIZE* = 0x00008D52
  GL_RENDERBUFFER_ALPHA_SIZE* = 0x00008D53
  GL_RENDERBUFFER_DEPTH_SIZE* = 0x00008D54
  GL_RENDERBUFFER_STENCIL_SIZE* = 0x00008D55
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE* = 0x00008CD0
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME* = 0x00008CD1
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL* = 0x00008CD2
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE* = 0x00008CD3
  GL_COLOR_ATTACHMENT0* = 0x00008CE0
  GL_DEPTH_ATTACHMENT* = 0x00008D00
  GL_STENCIL_ATTACHMENT* = 0x00008D20
  GL_NONE* = 0
  GL_FRAMEBUFFER_COMPLETE* = 0x00008CD5
  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT* = 0x00008CD6
  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT* = 0x00008CD7
  GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS* = 0x00008CD9
  GL_FRAMEBUFFER_UNSUPPORTED* = 0x00008CDD
  GL_FRAMEBUFFER_BINDING* = 0x00008CA6
  GL_RENDERBUFFER_BINDING* = 0x00008CA7
  GL_MAX_RENDERBUFFER_SIZE* = 0x000084E8
  GL_INVALID_FRAMEBUFFER_OPERATION* = 0x00000506

proc glActiveTexture*(texture: GlEnum) {.importc.}
  ## Select active texture unit.
  ##
  ## texture
  ##   Specifies which texture unit to make active. The number of texture units
  ##   is implementation dependent, but must be at least `8`. `texture` must be
  ##   one of `GL_TEXTURE`i, where `i` ranges from `0` to
  ##   `(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS - 1)`. The initial value is
  ##   `GL_TEXTURE0`.

proc glAttachShader*(program: GlUint, shader: GlUint) {.importc.}
  ## Attach a shader object to a program object.
  ##
  ## program
  ##   Specifies the program object to which a shader object will be attached.
  ## shader
  ##   Specifies the shader object that is to be attached.

proc glBindAttribLocation*(program: GlUint, index: GlUint, name: ptr GlChar) {.importc.}
  ## Associate a generic vertex attribute index with a named attribute variable.
  ##
  ## program
  ##   Specifies the handle of the program object in which the association is to
  ##   be made.
  ## index
  ##   Specifies the index of the generic vertex attribute to be bound.
  ## name
  ##   Specifies a null terminated string containing the name of the vertex
  ##   shader attribute variable to which index is to be bound.

proc glBindBuffer*(target: GlEnum, buffer: GlUint) {.importc.}
  ## Bind a named buffer object.
  ##
  ## target
  ##   Specifies the target to which the buffer object is bound. The symbolic
  ##   constant must be `GL_ARRAY_BUFFER` or `GL_ELEMENT_ARRAY_BUFFER`.
  ## buffer
  ##   Specifies the name of a buffer object.

proc glBindFramebuffer*(target: GlEnum, framebuffer: GlUint) {.importc.}
  ## Bind a named framebuffer object.
  ##
  ## target
  ##   Specifies the target to which the framebuffer object is bound. The
  ##   symbolic constant must be `GL_FRAME_BUFFER`.
  ## framebuffer
  ##   Specifies the name of a framebuffer object.

proc glBindRenderbuffer*(target: GlEnum, renderbuffer: GlUint) {.importc.}
  ## Bind a named renderbuffer object.
  ##
  ## target
  ##   Specifies the target to which the renderbuffer object is bound. The
  ##   symbolic constant must be `GL_RENDER_BUFFER`.
  ## renderbuffer
  ##   Specifies the name of a renderbuffer object.

proc glBindTexture*(target: GlEnum, texture: GlUint) {.importc.}
  ## Bind a named texture to a texturing target.
  ##
  ## target
  ##   Specifies the target of the active texture unit to which the texture is
  ##   bound. Must be either `GL_TEXTURE_2D` or `GL_TEXTURE_CUBE_MAP`.
  ## texture
  ##   Specifies the name of a texture.

proc glBlendColor*(
  red: GlFloat, green: GlFloat, blue: GlFloat, alpha: GlFloat
) {.importc.}
  ## Set the blend color.
  ##
  ## red, green, blue, alpha
  ##   Specify the components of `GL_BLEND_COLOR`.

proc glBlendEquation*(mode: GlEnum) {.importc.}
  ## Specify the equation used for both the RGB blend equation and the Alpha
  ## blend equation.
  ##
  ## mode
  ##   Specifies how source and destination colors are combined. It must be
  ##   `GL_FUNC_ADD`, `GL_FUNC_SUBTRACT`, or `GL_FUNC_REVERSE_SUBTRACT`.

proc glBlendEquationSeparate*(modeRGB: GlEnum, modeAlpha: GlEnum) {.importc.}
  ## Set the RGB blend equation and the alpha blend equation separately.
  ##
  ## modeRGB
  ##   Specifies the RGB blend equation, how the red, green, and blue components
  ##   of the source and destination colors are combined. It must be
  ##   `GL_FUNC_ADD`, `GL_FUNC_SUBTRACT`, or `GL_FUNC_REVERSE_SUBTRACT`.
  ## modeAlpha
  ##   Specifies the alpha blend equation, how the alpha component of the source
  ##   and destination colors are combined. It must be `GL_FUNC_ADD`,
  ##   `GL_FUNC_SUBTRACT`, or `GL_FUNC_REVERSE_SUBTRACT`.

proc glBlendFunc*(sfactor: GlEnum, dfactor: GlEnum) {.importc.}
  ## Specify pixel arithmetic.
  ##
  ## sfactor
  ##   Specifies how the red, green, blue, and alpha source blending factors are
  ##   computed. The following symbolic constants are accepted: `GL_ZERO`,
  ##   `GL_ONE`, `GL_SRC_COLOR`, `GL_ONE_MINUS_SRC_COLOR`, `GL_DST_COLOR`,
  ##   `GL_ONE_MINUS_DST_COLOR`, `GL_SRC_ALPHA`, `GL_ONE_MINUS_SRC_ALPHA`,
  ##   `GL_DST_ALPHA`, `GL_ONE_MINUS_DST_ALPHA`, `GL_CONSTANT_COLOR`,
  ##   `GL_ONE_MINUS_CONSTANT_COLOR`, `GL_CONSTANT_ALPHA`,
  ##   `GL_ONE_MINUS_CONSTANT_ALPHA`, and `GL_SRC_ALPHA_SATURATE`.
  ##   The initial value is `GL_ONE`.
  ## dfactor
  ##   Specifies how the red, green, blue, and alpha destination blending
  ##   factors are computed. The following symbolic constants are accepted:
  ##   `GL_ZERO`, `GL_ONE`, `GL_SRC_COLOR`, `GL_ONE_MINUS_SRC_COLOR`,
  ##   `GL_DST_COLOR`, `GL_ONE_MINUS_DST_COLOR`, `GL_SRC_ALPHA`,
  ##   `GL_ONE_MINUS_SRC_ALPHA`, `GL_DST_ALPHA`, `GL_ONE_MINUS_DST_ALPHA`,
  ##   `GL_CONSTANT_COLOR`, `GL_ONE_MINUS_CONSTANT_COLOR`, `GL_CONSTANT_ALPHA`,
  ##   and `GL_ONE_MINUS_CONSTANT_ALPHA`. The initial value is `GL_ZERO`.

proc glBlendFuncSeparate*(
  sfactorRGB: GlEnum, dfactorRGB: GlEnum, sfactorAlpha: GlEnum, dfactorAlpha: GlEnum
) {.importc.}
  ## Specify pixel arithmetic for RGB and alpha components separately.
  ##
  ## srcRGB
  ##   Specifies how the red, green, and blue blending factors are computed. The
  ##   following symbolic constants are accepted: `GL_ZERO`, `GL_ONE`,
  ##   `GL_SRC_COLOR`, `GL_ONE_MINUS_SRC_COLOR`, `GL_DST_COLOR`,
  ##   `GL_ONE_MINUS_DST_COLOR`, `GL_SRC_ALPHA`, `GL_ONE_MINUS_SRC_ALPHA`,
  ##   `GL_DST_ALPHA`, `GL_ONE_MINUS_DST_ALPHA`, `GL_CONSTANT_COLOR`,
  ##   `GL_ONE_MINUS_CONSTANT_COLOR`, `GL_CONSTANT_ALPHA`,
  ##   `GL_ONE_MINUS_CONSTANT_ALPHA`, and `GL_SRC_ALPHA_SATURATE`. The initial
  ##   value is `GL_ONE`.
  ## dstRGB
  ##   Specifies how the red, green, and blue destination blending factors are
  ##   computed. The following symbolic constants are accepted: `GL_ZERO`,
  ##   `GL_ONE`, `GL_SRC_COLOR`, `GL_ONE_MINUS_SRC_COLOR`, `GL_DST_COLOR`,
  ##   `GL_ONE_MINUS_DST_COLOR`, `GL_SRC_ALPHA`, `GL_ONE_MINUS_SRC_ALPHA`,
  ##   `GL_DST_ALPHA`, `GL_ONE_MINUS_DST_ALPHA`. `GL_CONSTANT_COLOR`,
  ##   `GL_ONE_MINUS_CONSTANT_COLOR`, `GL_CONSTANT_ALPHA`, and
  ##   `GL_ONE_MINUS_CONSTANT_ALPHA`. The initial value is `GL_ZERO`.
  ## srcAlpha
  ##   Specified how the alpha source blending factor is computed. The same
  ##   symbolic constants are accepted as for `srcRGB`. The initial value is
  ##   `GL_ONE`.
  ## dstAlpha
  ##   Specified how the alpha destination blending factor is computed. The same
  ##   symbolic constants are accepted as for `dstRGB`. The initial value is
  ##   `GL_ZERO`.

proc glBufferData*(
  target: GlEnum, size: GlSizeiptr, data: pointer, usage: GlEnum
) {.importc.}
  ## Create and initialize a buffer object's data store.
  ##
  ## target
  ##   Specifies the target buffer object. The symbolic constant must be
  ##   `GL_ARRAY_BUFFER` or `GL_ELEMENT_ARRAY_BUFFER`.
  ## size
  ##   Specifies the size in bytes of the buffer object's new data store.
  ## data
  ##   Specifies a pointer to data that will be copied into the data store for
  ##   initialization, or `nil` if no data is to be copied.
  ## usage
  ##   Specifies the expected usage pattern of the data store. The symbolic
  ##   constant must be `GL_STREAM_DRAW`, `GL_STATIC_DRAW` or `GL_DYNAMIC_DRAW`.

proc glBufferSubData*(
  target: GlEnum, offset: GlIntptr, size: GlSizeiptr, data: pointer
) {.importc.}
  ## Update a subset of a buffer object's data store.
  ##
  ## target
  ##   Specifies the target buffer object. The symbolic constant must be
  ##   `GL_ARRAY_BUFFER` or `GL_ELEMENT_ARRAY_BUFFER`.
  ## offset
  ##   Specifies the offset into the buffer object's data store where data
  ##   replacement will begin, measured in bytes.
  ## size
  ##   Specifies the size in bytes of the data store region being replaced.
  ## data
  ##   Specifies a pointer to the new data that will be copied into the data
  ##   store.

proc glCheckFramebufferStatus*(target: GlEnum): GlEnum {.importc.}
  ## Return the framebuffer completeness status of a framebuffer object.
  ##
  ## target
  ##   Specifies the target framebuffer object. The symbolic constant must be
  ##   `GL_FRAME_BUFFER`.

proc glClear*(mask: GlBitfield) {.importc.}
  ## Clear buffers to preset values.
  ##
  ## mask
  ##   Bitwise OR of masks that indicate the buffers to be cleared. The three
  ##   masks are `GL_COLOR_BUFFER_BIT`, `GL_DEPTH_BUFFER_BIT`, and
  ##   `GL_STENCIL_BUFFER_BIT`.

proc glClearColor*(
  red: GlFloat, green: GlFloat, blue: GlFloat, alpha: GlFloat
) {.importc.}
  ## Specify clear values for the color buffers.
  ##
  ## red, green, blue, alpha
  ##   Specify the red, green, blue, and alpha values used when the color
  ##   buffers are cleared. The initial values are all `0`.

proc glClearDepthf*(d: GlFloat) {.importc.}
  ## Specify the clear value for the depth buffer.
  ##
  ## depth
  ##   Specifies the depth value used when the depth buffer is cleared. The
  ##   initial value is `1`.

proc glClearStencil*(s: GlInt) {.importc.}
  ## Specify the clear value for the stencil buffer.
  ##
  ## s
  ##   Specifies the index used when the stencil buffer is cleared. The initial
  ##   value is `0`.

proc glColorMask*(
  red: GlBoolean, green: GlBoolean, blue: GlBoolean, alpha: GlBoolean
) {.importc.}
  ## Enable and disable writing of frame buffer color components.
  ##
  ## red, green, blue, alpha
  ##   Specify whether red, green, blue, and alpha can or cannot be written into
  ##   the frame buffer. The initial values are all `GL_TRUE`, indicating that
  ##   the color components can be written.

proc glCompileShader*(shader: GlUint) {.importc.}
  ## Compile a shader object.
  ##
  ## shader
  ##   Specifies the shader object to be compiled.

proc glCompressedTexImage2D*(
  target: GlEnum,
  level: GlInt,
  internalformat: GlEnum,
  width: GlSizei,
  height: GlSizei,
  border: GlInt,
  imageSize: GlSizei,
  data: pointer,
) {.importc.}
  ## Specify a two-dimensional texture image in a compressed format.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level n is the nth mipmap reduction image.
  ## internalformat
  ##   Specifies the format of the compressed image data stored at address data.
  ## width
  ##   Specifies the width of the texture image. All implementations support 2D
  ##   texture images that are at least 64 texels wide and cube-mapped texture
  ##   images that are at least 16 texels wide.
  ## height
  ##   Specifies the height of the texture image. All implementations support 2D
  ##   texture images that are at least 64 texels high and cube-mapped texture
  ##   images that are at least 16 texels high.
  ## border
  ##   Specifies the width of the border. Must be `0`.
  ## imageSize
  ##   Specifies the number of unsigned bytes of image data starting at the
  ##   address specified by `data`.
  ## data
  ##   Specifies a pointer to the compressed image data in memory.

proc glCompressedTexSubImage2D*(
  target: GlEnum,
  level: GlInt,
  xoffset: GlInt,
  yoffset: GlInt,
  width: GlSizei,
  height: GlSizei,
  format: GlEnum,
  imageSize: GlSizei,
  data: pointer,
) {.importc.}
  ## Specify a two-dimensional texture subimage in a compressed format.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level n is the nth mipmap reduction image.
  ## xoffset
  ##   Specifies a texel offset in the x direction within the texture array.
  ## yoffset
  ##   Specifies a texel offset in the y direction within the texture array.
  ## width
  ##   Specifies the width of the texture subimage.
  ## height
  ##   Specifies the height of the texture subimage.
  ## format
  ##   Specifies the format of the compressed image data stored at address
  ##   data.
  ## imageSize
  ##   Specifies the number of unsigned bytes of image data starting at the
  ##   address specified by `data`.
  ## data
  ##   Specifies a pointer to the compressed image data in memory.

proc glCopyTexImage2D*(
  target: GlEnum,
  level: GlInt,
  internalformat: GlEnum,
  x: GlInt,
  y: GlInt,
  width: GlSizei,
  height: GlSizei,
  border: GlInt,
) {.importc.}
  ## Copy pixels into a 2D texture image.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level n is the nth mipmap reduction image.
  ## internalformat
  ##   Specifies the internal format of the texture. Must be one of the
  ##   following symbolic constants: `GL_ALPHA`, `GL_LUMINANCE`,
  ##   `GL_LUMINANCE_ALPHA`, `GL_RGB`, or `GL_RGBA`.
  ## x, y
  ##   Specify the window coordinates of the lower left corner of the
  ##   rectangular region of pixels to be copied.
  ## width
  ##   Specifies the width of the texture image. All implementations support
  ##   2D texture images that are at least 64 texels wide and cube-mapped
  ##   texture images that are at least 16 texels wide.
  ## height
  ##   Specifies the height of the texture image. All implementations support
  ##   2D texture images that are at least 64 texels high and cube-mapped
  ##   texture images that are at least 16 texels high.
  ## border
  ##   Specifies the width of the border. Must be `0`.

proc glCopyTexSubImage2D*(
  target: GlEnum,
  level: GlInt,
  xoffset: GlInt,
  yoffset: GlInt,
  x: GlInt,
  y: GlInt,
  width: GlSizei,
  height: GlSizei,
) {.importc.}
  ## Copy a two-dimensional texture subimage.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level n is the nth mipmap reduction image.
  ## xoffset
  ##   Specifies a texel offset in the x direction within the texture array.
  ## yoffset
  ##   Specifies a texel offset in the y direction within the texture array.
  ## x, y
  ##   Specify the window coordinates of the lower left corner of the
  ##   rectangular region of pixels to be copied.
  ## width
  ##   Specifies the width of the texture subimage.
  ## height
  ##   Specifies the height of the texture subimage.

proc glCreateProgram*(): GlUint {.importc.} ## Create a program object.

proc glCreateShader*(`type`: GlEnum): GlUint {.importc.}
  ## Create a shader object.
  ##
  ## shaderType
  ##   Specifies the type of shader to be created. Must be either
  ##   `GL_VERTEX_SHADER` or `GL_FRAGMENT_SHADER`.

proc glCullFace*(mode: GlEnum) {.importc.}
  ## Specify whether front- or back-facing polygons can be culled.
  ##
  ## mode
  ##   Specifies whether front- or back-facing polygons are candidates for
  ##   culling. Symbolic constants `GL_FRONT`, `GL_BACK` and `GL_FRONT_AND_BACK`
  ##   are accepted. The initial value is `GL_BACK`.

proc glDeleteBuffers*(n: GlSizei, buffers: ptr GlUint) {.importc.}
  ## Delete named buffer objects.
  ##
  ## n
  ##   Specifies the number of buffer objects to be deleted.
  ## buffers
  ##   Specifies an array of buffer objects to be deleted.

proc glDeleteFramebuffers*(n: GlSizei, framebuffers: ptr GlUint) {.importc.}
  ## Delete named framebuffer objects.
  ##
  ## n
  ##   Specifies the number of framebuffer objects to be deleted.
  ## framebuffers
  ##   Specifies an array of framebuffer objects to be deleted.

proc glDeleteProgram*(program: GlUint) {.importc.}
  ## Delete a program object.
  ##
  ## program
  ##   Specifies the program object to be deleted.

proc glDeleteRenderbuffers*(n: GlSizei, renderbuffers: ptr GlUint) {.importc.}
  ## Delete named renderbuffer objects.
  ##
  ## n
  ##   Specifies the number of renderbuffer objects to be deleted.
  ## renderbuffers
  ##   Specifies an array of renderbuffer objects to be deleted.

proc glDeleteShader*(shader: GlUint) {.importc.}
  ## Delete a shader object.
  ##
  ## shader
  ##   Specifies the shader object to be deleted.

proc glDeleteTextures*(n: GlSizei, textures: ptr GlUint) {.importc.}
  ## Delete named textures.
  ##
  ## n
  ##   Specifies the number of textures to be deleted.
  ## textures
  ##   Specifies an array of textures to be deleted.

proc glDepthFunc*(depthFunc: GlEnum) {.importc.}
  ## Specify the value used for depth buffer comparisons.
  ##
  ## depthFunc
  ##   Specifies the depth comparison function. Symbolic constants `GL_NEVER`,
  ##   `GL_LESS`, `GL_EQUAL`, `GL_LEQUAL`, `GL_GREATER`, `GL_NOTEQUAL`,
  ##   `GL_GEQUAL` and `GL_ALWAYS` are accepted. The initial value is `GL_LESS`.

proc glDepthMask*(flag: GlBoolean) {.importc.}
  ## Enable or disable writing into the depth buffer.
  ##
  ## flag
  ##   Specifies whether the depth buffer is enabled for writing. If flag is
  ##   `GL_FALSE`, depth buffer writing is disabled. Otherwise, it is enabled.
  ##   Initially, depth buffer writing is enabled.

proc glDepthRangef*(n: GlFloat, f: GlFloat) {.importc.}
  ## Specify mapping of depth values from normalized device coordinates to
  ## window coordinates.
  ##
  ## nearVal
  ##   Specifies the mapping of the near clipping plane to window coordinates.
  ##   The initial value is `0`.
  ## farVal
  ##   Specifies the mapping of the far clipping plane to window coordinates.
  ##   The initial value is `1`.

proc glDetachShader*(program: GlUint, shader: GlUint) {.importc.}
  ## Detach a shader object from a program object.
  ##
  ## program
  ##   Specifies the program object from which to detach the shader object.
  ## shader
  ##   Specifies the shader object to be detached.

proc glDisable*(cap: GlEnum) {.importc.}
  ## Disable server-side GL capabilities.
  ##
  ## cap
  ##   Specifies a symbolic constant indicating a GL capability.

proc glDisableVertexAttribArray*(index: GlUint) {.importc.}
  ## Disable a generic vertex attribute array.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be disabled.

proc glDrawArrays*(mode: GlEnum, first: GlInt, count: GlSizei) {.importc.}
  ## Render primitives from array data.
  ##
  ## mode
  ##   Specifies what kind of primitives to render. Symbolic constants
  ##   `GL_POINTS`, `GL_LINE_STRIP`, `GL_LINE_LOOP`, `GL_LINES`,
  ##   `GL_TRIANGLE_STRIP`, `GL_TRIANGLE_FAN` and `GL_TRIANGLES` are accepted.
  ## first
  ##   Specifies the starting index in the enabled arrays.
  ## count
  ##   Specifies the number of indices to be rendered.

proc glDrawElements*(
  mode: GlEnum, count: GlSizei, `type`: GlEnum, indices: pointer
) {.importc.}
  ## Render primitives from array data.
  ##
  ## mode
  ##   Specifies what kind of primitives to render. Symbolic constants
  ##   `GL_POINTS`, `GL_LINE_STRIP`, `GL_LINE_LOOP`, `GL_LINES`,
  ##   `GL_TRIANGLE_STRIP`, `GL_TRIANGLE_FAN`, and `GL_TRIANGLES` are accepted.
  ## count
  ##   Specifies the number of elements to be rendered.
  ## type
  ##   Specifies the type of the values in indices. Must be `GL_UNSIGNED_BYTE`
  ##   or `GL_UNSIGNED_SHORT`.
  ## indices
  ##   Specifies a pointer to the location where the indices are stored.

proc glEnable*(cap: GlEnum) {.importc.}
  ## Enable server-side GL capabilities.
  ##
  ## cap
  ##   Specifies a symbolic constant indicating a GL capability.

proc glEnableVertexAttribArray*(index: GlUint) {.importc.}
  ## Enable a generic vertex attribute array.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be enabled .

proc glFinish*() {.importc.} ## Block until all GL execution is complete.

proc glFlush*() {.importc.} ## Force execution of GL commands in finite time.

proc glFramebufferRenderbuffer*(
  target: GlEnum, attachment: GlEnum, renderbuffertarget: GlEnum, renderbuffer: GlUint
) {.importc.}
  ## Attach a renderbuffer object to a framebuffer object.
  ##
  ## target
  ##   Specifies the framebuffer target. The symbolic constant must be
  ##   `GL_FRAME_BUFFER`.
  ## attachment
  ##   Specifies the attachment point to which renderbuffer should be attached.
  ##   Must be one of the following symbolic constants: `GL_COLOR_ATTACHMENT0`,
  ##   `GL_DEPTH_ATTACHMENT`, or `GL_STENCIL_ATTACHMENT`.
  ## renderbuffertarget
  ##   Specifies the renderbuffer target. The symbolic constant must be
  ##   `GL_RENDER_BUFFER`.
  ## renderbuffer
  ##   Specifies the renderbuffer object that is to be attached.

proc glFramebufferTexture2D*(
  target: GlEnum, attachment: GlEnum, textarget: GlEnum, texture: GlUint, level: GlInt
) {.importc.}
  ## Attach a texture image to a framebuffer object.
  ##
  ## target
  ##   Specifies the framebuffer target. The symbolic constant must be
  ##   `GL_FRAME_BUFFER`.
  ## attachment
  ##   Specifies the attachment point to which an image from texture should be
  ##   attached. Must be one of the following symbolic constants:
  ##   `GL_COLOR_ATTACHMENT0`, `GL_DEPTH_ATTACHMENT` or `GL_STENCIL_ATTACHMENT`.
  ## textarget
  ##   Specifies the texture target. Must be one of the following symbolic
  ##   constants: `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## texture
  ##   Specifies the texture object whose image is to be attached.
  ## level
  ##   Specifies the mipmap level of the texture image to be attached, which
  ##   must be `0`.

proc glFrontFace*(mode: GlEnum) {.importc.}
  ## Define front- and back-facing polygons.
  ##
  ## mode
  ##   Specifies the orientation of front-facing polygons.`GL_CW` and `GL_CCW`
  ##   are accepted. The initial value is `GL_CCW`.

proc glGenBuffers*(n: GlSizei, buffers: ptr GlUint) {.importc.}
  ## Generate buffer object names.
  ##
  ## n
  ##   Specifies the number of buffer object names to be generated.
  ## buffers
  ##   Specifies an array in which the generated buffer object names are stored.

proc glGenerateMipmap*(target: GlEnum) {.importc.}
  ## Generate a complete set of mipmaps for a texture object.
  ##
  ## target
  ##   Specifies the texture target of the active texture unit to which the
  ##   texture object is bound whose mipmaps will be generated. Must be one of
  ##   the following symbolic constants: `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP`.

proc glGenFramebuffers*(n: GlSizei, framebuffers: ptr GlUint) {.importc.}
  ## Generate framebuffer object names.
  ##
  ## n
  ##   Specifies the number of framebuffer object names to be generated.
  ## framebuffers
  ##   Specifies an array in which the generated framebuffer object names are
  ##   stored.

proc glGenRenderbuffers*(n: GlSizei, renderbuffers: ptr GlUint) {.importc.}
  ## Generate renderbuffer object names.
  ##
  ## n
  ##   Specifies the number of renderbuffer object names to be generated.
  ## renderbuffers
  ##   Specifies an array in which the generated renderbuffer object names are
  ##   stored.

proc glGenTextures*(n: GlSizei, textures: ptr GlUint) {.importc.}
  ## Generate texture names.
  ##
  ## n
  ##   Specifies the number of texture names to be generated.
  ## textures
  ##   Specifies an array in which the generated texture names are stored.

proc glGetActiveAttrib*(
  program: GlUint,
  index: GlUint,
  bufSize: GlSizei,
  length: ptr GlSizei,
  size: ptr GlInt,
  `type`: ptr GlEnum,
  name: ptr GlChar,
) {.importc.}
  ## Return information about an active attribute variable.
  ##
  ## program
  ##  Specifies the program object to be queried.
  ## index
  ##   Specifies the index of the attribute variable to be queried.
  ## bufSize
  ##   Specifies the maximum number of characters OpenGL is allowed to write in
  ##   the character buffer indicated by name.
  ## length
  ##   Returns the number of characters actually written by OpenGL in the string
  ##   indicated by name (excluding the null terminator) if a value other than
  ##   `nil` is passed.
  ## size
  ##   Returns the size of the attribute variable.
  ## type
  ##   Returns the data type of the attribute variable.
  ## name
  ##   Returns a null terminated string containing the name of the attribute
  ##   variable.

proc glGetActiveUniform*(
  program: GlUint,
  index: GlUint,
  bufSize: GlSizei,
  length: ptr GlSizei,
  size: ptr GlInt,
  `type`: ptr GlEnum,
  name: ptr GlChar,
) {.importc.}
  ## Return information about an active uniform variable.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## index
  ##   Specifies the index of the uniform variable to be queried.
  ## bufSize
  ##   Specifies the maximum number of characters OpenGL is allowed to write in
  ##   the character buffer indicated by name.
  ## length
  ##   Returns the number of characters actually written by OpenGL in the string
  ##   indicated by name (excluding the null terminator) if a value other than
  ##   `nil` is passed.
  ## size
  ##   Returns the size of the uniform variable.
  ## type
  ##   Returns the data type of the uniform variable.
  ## name
  ##   Returns a null terminated string containing the name of the uniform
  ##   variable.

proc glGetAttachedShaders*(
  program: GlUint, maxCount: GlSizei, count: ptr GlSizei, shaders: ptr GlUint
) {.importc.}
  ## Return the handles of the shader objects attached to a program object.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## maxCount
  ##   Specifies the size of the array for storing the returned object names.
  ## count
  ##   Returns the number of names actually returned in shaders.
  ## shaders
  ##   Specifies an array that is used to return the names of attached shader
  ##   objects.

proc glGetAttribLocation*(program: GlUint, name: ptr GlChar): GlInt {.importc.}
  ## Return the location of an attribute variable.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## name
  ##   Points to a null terminated string containing the name of the attribute
  ##   variable whose location is to be queried.

proc glGetBooleanv*(pname: GlEnum, data: ptr GlBoolean) {.importc.}
  ## Return the value or values of a selected parameter.
  ##
  ## pname
  ##   Specifies the parameter value to be returned. See the full OpenGL ES
  ##   documentation for a list of accepted symbolic constants.
  ## params
  ##   Returns the value or values of the specified parameter.

proc glGetBufferParameteriv*(
  target: GlEnum, pname: GlEnum, params: ptr GlInt
) {.importc.}
  ## Return parameters of a buffer object.
  ##
  ## target
  ##   Specifies the target buffer object. The symbolic constant must be
  ##   `GL_ARRAY_BUFFER` or `GL_ELEMENT_ARRAY_BUFFER`.
  ## value
  ##   Specifies the symbolic name of a buffer object parameter. Accepted values
  ##   are `GL_BUFFER_SIZE` or `GL_BUFFER_USAGE`.
  ## data
  ##   Returns the requested parameter.

proc glGetError*(): GlEnum {.importc.} ## Return error information.

proc glGetFloatv*(pname: GlEnum, data: ptr GlFloat) {.importc.}
  ## Return the value or values of a selected parameter.
  ##
  ## pname
  ##   Specifies the parameter value to be returned. See the full OpenGL ES
  ##   documentation for a list of accepted symbolic constants.
  ## params
  ##   Returns the value or values of the specified parameter.

proc glGetFramebufferAttachmentParameteriv*(
  target: GlEnum, attachment: GlEnum, pname: GlEnum, params: ptr GlInt
) {.importc.}
  ## Return attachment parameters of a framebuffer object.
  ##
  ## target
  ##   Specifies the target framebuffer object. The symbolic constant must be
  ##   `GL_FRAME_BUFFER`.
  ## attachment
  ##   Specifies the symbolic name of a framebuffer object attachment point.
  ##   Accepted values are `GL_COLOR_ATTACHMENT0`, `GL_DEPTH_ATTACHMENT`, and
  ##   `GL_STENCIL_ATTACHMENT`.
  ## pname
  ##   Specifies the symbolic name of a framebuffer object attachment parameter.
  ##   Accepted values are `GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE`,
  ##   `GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME`,
  ##   `GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL`, and
  ##   `GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE`.
  ## params
  ##   Returns the requested parameter.

proc glGetIntegerv*(pname: GlEnum, data: ptr GlInt) {.importc.}
  ## Return the value or values of a selected parameter.
  ##
  ## pname
  ##   Specifies the parameter value to be returned. See the full OpenGL ES
  ##   documentation for a list of accepted symbolic constants.
  ## params
  ##   Returns the value or values of the specified parameter.

proc glGetProgramiv*(program: GlUint, pname: GlEnum, params: ptr GlInt) {.importc.}
  ## Return a parameter from a program object.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## pname
  ##   Specifies the object parameter. Accepted symbolic names are
  ##   `GL_DELETE_STATUS`, `GL_LINK_STATUS`, `GL_VALIDATE_STATUS`,
  ##   `GL_INFO_LOG_LENGTH`, `GL_ATTACHED_SHADERS`, `GL_ACTIVE_ATTRIBUTES`,
  ##   `GL_ACTIVE_ATTRIBUTE_MAX_LENGTH`, `GL_ACTIVE_UNIFORMS`,
  ##   `GL_ACTIVE_UNIFORM_MAX_LENGTH`.
  ## params
  ##   Returns the requested object parameter.

proc glGetProgramInfoLog*(
  program: GlUint, bufSize: GlSizei, length: ptr GlSizei, infoLog: ptr GlChar
) {.importc.}
  ## Return the information log for a program object.
  ##
  ## program
  ##   Specifies the program object whose information log is to be queried.
  ## maxLength
  ##  Specifies the size of the character buffer for storing the returned
  ##  information log.
  ## length
  ##   Returns the length of the string returned in infoLog (excluding the null
  ##   terminator).
  ## infoLog
  ##   Specifies an array of characters that is used to return the information
  ##   log.

proc glGetRenderbufferParameteriv*(
  target: GlEnum, pname: GlEnum, params: ptr GlInt
) {.importc.}
  ## Return parameters of a renderbuffer object.
  ##
  ## target
  ##   Specifies the target renderbuffer object. The symbolic constant must be
  ##   `GL_RENDER_BUFFER`.
  ## pname
  ##   Specifies the symbolic name of a renderbuffer object parameter. Accepted
  ##   values are `GL_RENDERBUFFER_WIDTH`, `GL_RENDERBUFFER_HEIGHT`,
  ##   `GL_RENDERBUFFER_INTERNAL_FORMAT`, `GL_RENDERBUFFER_RED_SIZE`,
  ##   `GL_RENDERBUFFER_GREEN_SIZE`, `GL_RENDERBUFFER_BLUE_SIZE`,
  ##   `GL_RENDERBUFFER_ALPHA_SIZE`, `GL_RENDERBUFFER_DEPTH_SIZE`, or
  ##   `GL_RENDERBUFFER_STENCIL_SIZE`.
  ## params
  ##   Returns the requested parameter.

proc glGetShaderiv*(shader: GlUint, pname: GlEnum, params: ptr GlInt) {.importc.}
  ## Return a parameter from a shader object.
  ##
  ## shader
  ##   Specifies the shader object to be queried.
  ## pname
  ##   Specifies the object parameter. Accepted symbolic names are
  ##   `GL_SHADER_TYPE`, `GL_DELETE_STATUS`, `GL_COMPILE_STATUS`,
  ##   `GL_INFO_LOG_LENGTH`, `GL_SHADER_SOURCE_LENGTH`.
  ## params
  ##   Returns the requested object parameter.

proc glGetShaderInfoLog*(
  shader: GlUint, bufSize: GlSizei, length: ptr GlSizei, infoLog: ptr GlChar
) {.importc.}
  ## Return the information log for a shader object.
  ##
  ## shader
  ##   Specifies the shader object whose information log is to be queried.
  ## maxLength
  ##   Specifies the size of the character buffer for storing the returned
  ##   information log.
  ## length
  ##   Returns the length of the string returned in `infoLog` (excluding the
  ##   null terminator).
  ## infoLog
  ##   Specifies an array of characters that is used to return the information
  ##   log.

proc glGetShaderPrecisionFormat*(
  shadertype: GlEnum, precisiontype: GlEnum, range: ptr GlInt, precision: ptr GlInt
) {.importc.}
  ## Return the range and precision for different shader numeric formats.
  ##
  ## shaderType
  ##   Specifies the type of shader to query. Must be either `GL_VERTEX_SHADER`
  ##   or `GL_FRAGMENT_SHADER`.
  ## precisionType
  ##   Specifies the numeric format to query, corresponding to a shader
  ##   precision qualifier and variable type. Must be one of `GL_LOW_FLOAT`,
  ##   `GL_MEDIUM_FLOAT`, `GL_HIGH_FLOAT`, `GL_LOW_INT`, `GL_MEDIUM_INT`, or
  ##   `GL_HIGH_INT`.
  ## range
  ##   Specifies a pointer to the two-element array in which the log 2 of the
  ##   minimum and maximum representable magnitudes of the format are returned.
  ## precision
  ##   Specifies a pointer to the location in which the log 2 of the precision
  ##   of the format is returned.

proc glGetShaderSource*(
  shader: GlUint, bufSize: GlSizei, length: ptr GlSizei, source: ptr GlChar
) {.importc.}
  ## Return the source code string from a shader object.
  ##
  ## shader
  ##   Specifies the shader object to be queried.
  ## bufSize
  ##   Specifies the size of the character buffer for storing the returned
  ##   source code string.
  ## length
  ##   Returns the length of the string returned in source (excluding the null
  ##   terminator).
  ## source
  ##   Specifies an array of characters that is used to return the source code
  ##  string.

proc glGetString*(name: GlEnum): ptr GlUbyte {.importc.}
  ## Return a string describing the current GL connection.
  ##
  ## name
  ##   Specifies a symbolic constant, one of `GL_VENDOR`, `GL_RENDERER`,
  ##   `GL_VERSION`,`GL_SHADING_LANGUAGE_VERSION`, or `GL_EXTENSIONS`.

proc glGetTexParameterfv*(
  target: GlEnum, pname: GlEnum, params: ptr GlFloat
) {.importc.}
  ## Return texture parameter values.
  ##
  ## target
  ##   Specifies the symbolic name of the target texture of the active texture
  ##   unit. `GL_TEXTURE_2D` and `GL_TEXTURE_CUBE_MAP` are accepted.
  ## pname
  ##   Specifies the symbolic name of a texture parameter.
  ##   `GL_TEXTURE_MAG_FILTER`, `GL_TEXTURE_MIN_FILTER`, `GL_TEXTURE_WRAP_S`,
  ##   and `GL_TEXTURE_WRAP_T` are accepted.
  ## params
  ##   Returns the texture parameter.

proc glGetTexParameteriv*(target: GlEnum, pname: GlEnum, params: ptr GlInt) {.importc.}
  ## Return texture parameter values.
  ##
  ## target
  ##   Specifies the symbolic name of the target texture of the active texture
  ##   unit. `GL_TEXTURE_2D` and `GL_TEXTURE_CUBE_MAP` are accepted.
  ## pname
  ##   Specifies the symbolic name of a texture parameter.
  ##   `GL_TEXTURE_MAG_FILTER`, `GL_TEXTURE_MIN_FILTER`, `GL_TEXTURE_WRAP_S`,
  ##   and `GL_TEXTURE_WRAP_T` are accepted.
  ## params
  ##   Returns the texture parameter.

proc glGetUniformfv*(program: GlUint, location: GlInt, params: ptr GlFloat) {.importc.}
  ## Return the value of a uniform variable.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## location
  ##   Specifies the location of the uniform variable to be queried.
  ## params
  ##   Returns the value of the specified uniform variable.

proc glGetUniformiv*(program: GlUint, location: GlInt, params: ptr GlInt) {.importc.}
  ## Return the value of a uniform variable.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## location
  ##   Specifies the location of the uniform variable to be queried.
  ## params
  ##   Returns the value of the specified uniform variable.

proc glGetUniformLocation*(program: GlUint, name: ptr GlChar): GlInt {.importc.}
  ## Return the location of a uniform variable.
  ##
  ## program
  ##   Specifies the program object to be queried.
  ## name
  ##   Points to a null terminated string containing the name of the uniform
  ##   variable whose location is to be queried.

proc glGetVertexAttribfv*(index: GlUint, pname: GlEnum, params: ptr GlFloat) {.importc.}
  ## Return a generic vertex attribute parameter.
  ##
  ## index
  ##   Specifies the generic vertex attribute parameter to be queried.
  ## pname
  ##   Specifies the symbolic name of the vertex attribute parameter to be
  ##   queried. Accepted values are `GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_ENABLED`, `GL_VERTEX_ATTRIB_ARRAY_SIZE`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_STRIDE`, `GL_VERTEX_ATTRIB_ARRAY_TYPE`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_NORMALIZED`, or `GL_CURRENT_VERTEX_ATTRIB`.
  ## params
  ##   Returns the requested data.

proc glGetVertexAttribiv*(index: GlUint, pname: GlEnum, params: ptr GlInt) {.importc.}
  ## Return a generic vertex attribute parameter.
  ##
  ## index
  ##   Specifies the generic vertex attribute parameter to be queried.
  ## pname
  ##   Specifies the symbolic name of the vertex attribute parameter to be
  ##   queried. Accepted values are `GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_ENABLED`, `GL_VERTEX_ATTRIB_ARRAY_SIZE`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_STRIDE`, `GL_VERTEX_ATTRIB_ARRAY_TYPE`,
  ##   `GL_VERTEX_ATTRIB_ARRAY_NORMALIZED`, or `GL_CURRENT_VERTEX_ATTRIB`.
  ## params
  ##   Returns the requested data.

proc glGetVertexAttribPointerv*(
  index: GlUint, pname: GlEnum, pointer: ptr pointer
) {.importc.}
  ## Return the address of the specified generic vertex attribute pointer.
  ##
  ## index
  ##   Specifies the generic vertex attribute parameter to be returned.
  ## pname
  ##   Specifies the symbolic name of the generic vertex attribute parameter to
  ##   be returned. Must be `glVertexAttribArrayPointer`.
  ## pointer
  ##   Returns the pointer value.

proc glHint*(target: GlEnum, mode: GlEnum) {.importc.}
  ## Specify implementation-specific hints.
  ##
  ## target
  ##   Specifies a symbolic constant indicating the behavior to be controlled.
  ##   `glGenerateMipmapHint` is accepted.
  ## mode
  ##   Specifies a symbolic constant indicating the desired behavior.
  ##   `GL_FASTEST`, `GL_NICEST`, and `GL_DONT_CARE` are accepted.

proc glIsBuffer*(buffer: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a buffer object.
  ##
  ## buffer
  ##   Specifies a value that may be the name of a buffer object.

proc glIsEnabled*(cap: GlEnum): GlBoolean {.importc.}
  ## Test whether a capability is enabled.
  ##
  ## cap
  ##   Specifies a symbolic constant indicating a GL capability.

proc glIsFramebuffer*(framebuffer: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a framebuffer object.
  ##
  ## framebuffer
  ##   Specifies a value that may be the name of a framebuffer object.

proc glIsProgram*(program: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a program object.
  ##
  ## program
  ##   Specifies a potential program object.

proc glIsRenderbuffer*(renderbuffer: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a renderbuffer object.
  ##
  ## renderbuffer
  ##   Specifies a value that may be the name of a renderbuffer object.

proc glIsShader*(shader: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a shader object.
  ##
  ## shader
  ##   Specifies a potential shader object.

proc glIsTexture*(texture: GlUint): GlBoolean {.importc.}
  ## Determine if a name corresponds to a texture.
  ##
  ## texture
  ##   Specifies a value that may be the name of a texture.

proc glLineWidth*(width: GlFloat) {.importc.}
  ## Specify the width of rasterized lines.
  ##
  ## width
  ##   Specifies the width of rasterized lines. The initial value is `1`.

proc glLinkProgram*(program: GlUint) {.importc.}
  ## Link a program object.
  ##
  ## program
  ##   Specifies the handle of the program object to be linked.

proc glPixelStorei*(pname: GlEnum, param: GlInt) {.importc.}
  ## Set pixel storage modes.
  ##
  ## pname
  ##   Specifies the symbolic name of the parameter to be set. One value affects
  ##   the packing of pixel data into memory: `GL_PACK_ALIGNMENT`. The other
  ##   affects the unpacking of pixel data from memory: `GL_UNPACK_ALIGNMENT`.
  ## param
  ##   Specifies the value that pname is set to.

proc glPolygonOffset*(factor: GlFloat, units: GlFloat) {.importc.}
  ## Set the scale and units used to calculate depth values.
  ##
  ## factor
  ##   Specifies a scale factor that is used to create a variable depth offset
  ##   for each polygon. The initial value is `0`.
  ## units
  ##   Is multiplied by an implementation-specific value to create a constant
  ##   depth offset. The initial value is `0`.

proc glReadPixels*(
  x: GlInt,
  y: GlInt,
  width: GlSizei,
  height: GlSizei,
  format: GlEnum,
  `type`: GlEnum,
  pixels: pointer,
) {.importc.}
  ## Read a block of pixels from the frame buffer.
  ##
  ## x, y
  ##   Specify the window coordinates of the first pixel that is read from the
  ##   frame buffer. This location is the lower left corner of a rectangular
  ##   block of pixels.
  ## width, height
  ##   Specify the dimensions of the pixel rectangle. `width` and `height` of
  ##   one correspond to a single pixel.
  ## format
  ##   Specifies the format of the pixel data. The following symbolic values are
  ##   accepted: `GL_ALPHA`, `GL_RGB`, and `GL_RGBA`.
  ## type
  ##   Specifies the data type of the pixel data. Must be one of
  ##   `GL_UNSIGNED_BYTE`, `GL_UNSIGNED_SHORT565`, `GL_UNSIGNED_SHORT4444`, or
  ##   `GL_UNSIGNED_SHORT5551`.
  ## data
  ##   Returns the pixel data.

proc glReleaseShaderCompiler*() {.importc.}
  ## Release resources allocated by the shader compiler.

proc glRenderbufferStorage*(
  target: GlEnum, internalformat: GlEnum, width: GlSizei, height: GlSizei
) {.importc.}
  ## Create and initialize a renderbuffer object's data store.
  ##
  ## target
  ##   Specifies the renderbuffer target. The symbolic constant must be
  ##   `GL_RENDER_BUFFER`.
  ## internalformat
  ##   Specifies the color-renderable, depth-renderable, or stencil-renderable
  ##   format of the renderbuffer. Must be one of the following symbolic
  ##   constants: `GL_RGBA4`, `GL_RGB565`, `GL_RGB5_A1`, `GL_DEPTH_COMPONENT16`,
  ##   or `GL_STENCIL_INDEX8`.
  ## width
  ##   Specifies the width of the renderbuffer in pixels.
  ## height
  ##   Specifies the height of the renderbuffer in pixels.

proc glSampleCoverage*(value: GlFloat, invert: GlBoolean) {.importc.}
  ## Specify multisample coverage parameters.
  ##
  ## value
  ##   Specify a single floating-point sample coverage value. The value is
  ##   clamped to the range `0 1`. The initial value is `1.0`.
  ## invert
  ##   Specify a single boolean value representing if the coverage masks should
  ##   be inverted. `GL_TRUE` and `GL_FALSE` are accepted. The initial value is
  ##   `GL_FALSE`.

proc glScissor*(x: GlInt, y: GlInt, width: GlSizei, height: GlSizei) {.importc.}
  ## Define the scissor box.
  ##
  ## x, y
  ##   Specify the lower left corner of the scissor box. Initially `(0, 0)`.
  ## width, height
  ##   Specify the width and height of the scissor box. When a GL context is
  ##   first attached to a window, `width` and `height` are set to the
  ##   dimensions of that window.

proc glShaderBinary*(
  count: GlSizei,
  shaders: ptr GlUint,
  binaryformat: GlEnum,
  binary: pointer,
  length: GlSizei,
) {.importc.}
  ## Load a precompiled shader binary.
  ##
  ## n
  ##   Specifies the number of shader object handles present in shaders.
  ## shaders
  ##   Specifies a pointer to an array of shader object handles into which the
  ##   shader binary will be loaded.
  ## binaryformat
  ##   Specifies the shader binary format.
  ## binary
  ##   Specifies a pointer to the shader binary data in client memory.
  ## length
  ##   Specifies the length of the shader binary data in bytes.

proc glShaderSource*(
  shader: GlUint, count: GlSizei, string: ptr ptr GlChar, length: ptr GlInt
) {.importc.}
  ## Replace the source code in a shader object.
  ##
  ## shader
  ##   Specifies the handle of the shader object whose source code is to be
  ##   replaced.
  ## count
  ##   Specifies the number of elements in the string and length arrays.
  ## string
  ##   Specifies an array of pointers to strings containing the source code to
  ##   be loaded into the shader.
  ## length
  ##   Specifies an array of string lengths.

proc glStencilFunc*(stencilFunc: GlEnum, reference: GlInt, mask: GlUint) {.importc.}
  ## Set front and back function and reference value for stencil testing.
  ##
  ## stencilFunc
  ##   Specifies the test function. Eight symbolic constants are valid:
  ##   `GL_NEVER`, `GL_LESS`, `GL_LEQUAL`, `GL_GREATER`, `GL_GEQUAL`,
  ##   `GL_EQUAL`, `GL_NOTEQUAL`, and `GL_ALWAYS`. The initial value is
  ##   `GL_ALWAYS`.
  ## reference
  ##   Specifies the reference value for the stencil test. `reference` is
  ##   clamped to the range `0 2n-1`, where `n` is the number of bitplanes in
  ##   the stencil buffer. The initial value is `0`.
  ## mask
  ##   Specifies a mask that is ANDed with both the reference value and the
  ##   stored stencil value when the test is done. The initial value is all 1's.

proc glStencilFuncSeparate*(
  face: GlEnum, stencilFunc: GlEnum, reference: GlInt, mask: GlUint
) {.importc.}
  ## Set front and/or back function and reference value for stencil testing.
  ##
  ## face
  ##   Specifies whether front and/or back stencil state is updated. Three
  ##   symbolic constants are valid: `GL_FRONT`, `GL_BACK`, and
  ##   `GL_FRONT_AND_BACK`.
  ## stencilFunc
  ##   Specifies the test function. Eight symbolic constants are valid:
  ##  `GL_NEVER`, `GL_LESS`, `GL_LEQUAL`, `GL_GREATER`, `GL_GEQUAL`, `GL_EQUAL`,
  ##  `GL_NOTEQUAL`, and `GL_ALWAYS`. The initial value is `GL_ALWAYS`.
  ## reference
  ##   Specifies the reference value for the stencil test. `reference` is
  ##   clamped to the range `0 2n-1`, where `n` is the number of bitplanes in
  ##   the stencil buffer. The initial value is `0`.
  ## mask
  ##   Specifies a mask that is ANDed with both the reference value and the
  ##   stored stencil value when the test is done. The initial value is all 1's.

proc glStencilMask*(mask: GlUint) {.importc.}
  ## Control the front and back writing of individual bits in the stencil
  ## planes.
  ##
  ## mask
  ##   Specifies a bit mask to enable and disable writing of individual bits in
  ##   the stencil planes. Initially, the mask is all 1's.

proc glStencilMaskSeparate*(face: GlEnum, mask: GlUint) {.importc.}
  ## Control the front and/or back writing of individual bits in the stencil
  ## planes.
  ##
  ## face
  ##   Specifies whether the front and/or back stencil writemask is updated.
  ##   Three symbolic constants are valid: `GL_FRONT`, `GL_BACK`, and
  ##   `GL_FRONT_AND_BACK`.
  ## mask
  ##   Specifies a bit mask to enable and disable writing of individual bits in
  ##   the stencil planes. Initially, the mask is all 1's.

proc glStencilOp*(fail: GlEnum, zfail: GlEnum, zpass: GlEnum) {.importc.}
  ## Set front and back stencil test actions.
  ##
  ## sfail
  ##   Specifies the action to take when the stencil test fails. Eight symbolic
  ##   constants are accepted: `GL_KEEP`, `GL_ZERO`, `GL_REPLACE`, `GL_INCR`,
  ##   `GL_INCR_WRAP`, `GL_DECR`, `GL_DECR_WRAP`, and `GL_INVERT`. The initial
  ##   value is `GL_KEEP`.
  ## dpfail
  ##   Specifies the stencil action when the stencil test passes, but the depth
  ##   test fails. `dpfail` accepts the same symbolic constants as `sfail`. The
  ##   initial value is `GL_KEEP`.
  ## dppass
  ##   Specifies the stencil action when both the stencil test and the depth
  ##   test pass, or when the stencil test passes and either there is no depth
  ##   buffer or depth testing is not enabled. `dppass` accepts the same
  ##   symbolic constants as `sfail`. The initial value is `GL_KEEP`.

proc glStencilOpSeparate*(
  face: GlEnum, sfail: GlEnum, dpfail: GlEnum, dppass: GlEnum
) {.importc.}
  ## Set front and/or back stencil test actions.
  ##
  ## face
  ##   Specifies whether front and/or back stencil state is updated. Three
  ##   symbolic constants are valid: `GL_FRONT`, `GL_BACK`, and
  ##   `GL_FRONT_AND_BACK`.
  ## sfail
  ##   Specifies the action to take when the stencil test fails. Eight symbolic
  ##   constants are accepted: `GL_KEEP`, `GL_ZERO`, `GL_REPLACE`, `GL_INCR`,
  ##   `GL_INCR_WRAP`, `GL_DECR`, `GL_DECR_WRAP`, and `GL_INVERT`. The initial
  ##   value is `GL_KEEP`.
  ## dpfail
  ##   Specifies the stencil action when the stencil test passes, but the depth
  ##   test fails. `dpfail` accepts the same symbolic constants as `sfail`. The
  ##   initial value is `GL_KEEP`.
  ## dppass
  ##   Specifies the stencil action when both the stencil test and the depth
  ##   test pass, or when the stencil test passes and either there is no depth
  ##   buffer or depth testing is not enabled. `dppass` accepts the same
  ##   symbolic constants as `sfail`. The initial value is `GL_KEEP`.

proc glTexImage2D*(
  target: GlEnum,
  level: GlInt,
  internalformat: GlInt,
  width: GlSizei,
  height: GlSizei,
  border: GlInt,
  format: GlEnum,
  `type`: GlEnum,
  pixels: pointer,
) {.importc.}
  ## Specify a two-dimensional texture image.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level `n` is the `n`th mipmap reduction image.
  ## internalformat
  ##   Specifies the internal format of the texture. Must be one of the
  ##   following symbolic constants: `GL_ALPHA`, `GL_LUMINANCE`,
  ##   `GL_LUMINANCE_ALPHA`, `GL_RGB`, `GL_RGBA`.
  ## width
  ##   Specifies the width of the texture image. All implementations support 2D
  ##   texture images that are at least 64 texels wide and cube-mapped texture
  ##   images that are at least 16 texels wide.
  ## height
  ##   Specifies the height of the texture image All implementations support 2D
  ##   texture images that are at least 64 texels high and cube-mapped texture
  ##   images that are at least 16 texels high.
  ## border
  ##   Specifies the width of the border. Must be `0`.
  ## format
  ##   Specifies the format of the texel data. Must match `internalformat`. The
  ##   following symbolic values are accepted: `GL_ALPHA`, `GL_RGB`, `GL_RGBA`,
  ##   `GL_LUMINANCE`, and `GL_LUMINANCE_ALPHA`.
  ## type
  ##   Specifies the data type of the texel data. The following symbolic values
  ##   are accepted: `GL_UNSIGNED_BYTE`, `GL_UNSIGNED_SHORT565`,
  ##   `GL_UNSIGNED_SHORT4444`, and `GL_UNSIGNED_SHORT5551`.
  ## data
  ##   Specifies a pointer to the image data in memory.

proc glTexParameterf*(target: GlEnum, pname: GlEnum, param: GlFloat) {.importc.}
  ## Set texture parameters,
  ##
  ## target
  ##   Specifies the target texture of the active texture unit, which must be
  ##   either `GL_TEXTURE_2D` or `GL_TEXTURE_CUBE_MAP`.
  ## pname
  ##   Specifies the symbolic name of a single-valued texture parameter. `pname`
  ##   can be one of the following: `GL_TEXTURE_MIN_FILTER`,
  ##   `GL_TEXTURE_MAG_FILTER`, `GL_TEXTURE_WRAP_S`, or `GL_TEXTURE_WRAP_T`.
  ## param
  ##   Specifies the value of pname.

proc glTexParameterfv*(target: GlEnum, pname: GlEnum, params: ptr GlFloat) {.importc.}
  ## Set texture parameters,
  ##
  ## target
  ##   Specifies the target texture of the active texture unit, which must be
  ##   either `GL_TEXTURE_2D` or `GL_TEXTURE_CUBE_MAP`.
  ## pname
  ##   Specifies the symbolic name of a texture parameter. `pname` can be one of
  ##   the following: `GL_TEXTURE_MIN_FILTER`, `GL_TEXTURE_MAG_FILTER`,
  ##   `GL_TEXTURE_WRAP_S`, or `GL_TEXTURE_WRAP_T`.
  ## params
  ##   Specifies a pointer to an array where the value of pname is stored.

proc glTexParameteri*(target: GlEnum, pname: GlEnum, param: GlInt) {.importc.}
  ## Set texture parameters,
  ##
  ## target
  ##   Specifies the target texture of the active texture unit, which must be
  ##   either `GL_TEXTURE_2D` or `GL_TEXTURE_CUBE_MAP`.
  ## pname
  ##   Specifies the symbolic name of a single-valued texture parameter. `pname`
  ##   can be one of the following: `GL_TEXTURE_MIN_FILTER`,
  ##   `GL_TEXTURE_MAG_FILTER`, `GL_TEXTURE_WRAP_S`, or `GL_TEXTURE_WRAP_T`.
  ## param
  ##   Specifies the value of pname.

proc glTexParameteriv*(target: GlEnum, pname: GlEnum, params: ptr GlInt) {.importc.}
  ## Set texture parameters,
  ##
  ## target
  ##   Specifies the target texture of the active texture unit, which must be
  ##   either `GL_TEXTURE_2D` or `GL_TEXTURE_CUBE_MAP`.
  ## pname
  ##   Specifies the symbolic name of a texture parameter. `pname` can be one of
  ##   the following: `GL_TEXTURE_MIN_FILTER`, `GL_TEXTURE_MAG_FILTER`,
  ##   `GL_TEXTURE_WRAP_S`, or `GL_TEXTURE_WRAP_T`.
  ## params
  ##   Specifies a pointer to an array where the value of pname is stored.

proc glTexSubImage2D*(
  target: GlEnum,
  level: GlInt,
  xoffset: GlInt,
  yoffset: GlInt,
  width: GlSizei,
  height: GlSizei,
  format: GlEnum,
  `type`: GlEnum,
  pixels: pointer,
) {.importc.}
  ## Specify a two-dimensional texture subimage.
  ##
  ## target
  ##   Specifies the target texture of the active texture unit. Must be
  ##   `GL_TEXTURE_2D`, `GL_TEXTURE_CUBE_MAP_POSITIVE_X`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_X`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Y`,
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Y`, `GL_TEXTURE_CUBE_MAP_POSITIVE_Z`, or
  ##   `GL_TEXTURE_CUBE_MAP_NEGATIVE_Z`.
  ## level
  ##   Specifies the level-of-detail number. Level 0 is the base image level.
  ##   Level n is the nth mipmap reduction image.
  ## xoffset
  ##   Specifies a texel offset in the x direction within the texture array.
  ## yoffset
  ##   Specifies a texel offset in the y direction within the texture array.
  ## width
  ##   Specifies the width of the texture subimage.
  ## height
  ##   Specifies the height of the texture subimage.
  ## format
  ##   Specifies the format of the pixel data. The following symbolic values are
  ##   accepted: `GL_ALPHA`, `GL_RGB`, `GL_RGBA`, `GL_LUMINANCE`, and
  ##   `GL_LUMINANCE_ALPHA`.
  ## type
  ##   Specifies the data type of the pixel data. The following symbolic values
  ##   are accepted: `GL_UNSIGNED_BYTE`, `GL_UNSIGNED_SHORT565`,
  ##   `GL_UNSIGNED_SHORT4444`, and `GL_UNSIGNED_SHORT5551`.
  ## data
  ##   Specifies a pointer to the image data in memory.

proc glUniform1f*(location: GlInt, v0: GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform1fv*(location: GlInt, count: GlSizei, value: ptr GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform1i*(location: GlInt, v0: GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform1iv*(location: GlInt, count: GlSizei, value: ptr GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform2f*(location: GlInt, v0: GlFloat, v1: GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform2fv*(location: GlInt, count: GlSizei, value: ptr GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform2i*(location: GlInt, v0: GlInt, v1: GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform2iv*(location: GlInt, count: GlSizei, value: ptr GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform3f*(location: GlInt, v0: GlFloat, v1: GlFloat, v2: GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform3fv*(location: GlInt, count: GlSizei, value: ptr GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform3i*(location: GlInt, v0: GlInt, v1: GlInt, v2: GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform3iv*(location: GlInt, count: GlSizei, value: ptr GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform4f*(
  location: GlInt, v0: GlFloat, v1: GlFloat, v2: GlFloat, v3: GlFloat
) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform4fv*(location: GlInt, count: GlSizei, value: ptr GlFloat) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniform4i*(
  location: GlInt, v0: GlInt, v1: GlInt, v2: GlInt, v3: GlInt
) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform variable to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified uniform variable.

proc glUniform4iv*(location: GlInt, count: GlSizei, value: ptr GlInt) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of elements that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array, and `1` or more if
  ##   it is an array.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniformMatrix2fv*(
  location: GlInt, count: GlSizei, transpose: GlBoolean, value: ptr GlFloat
) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of matrices that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array of matrices, and `1`
  ##   or more if it is an array of matrices.
  ## transpose
  ##   Specifies whether to transpose the matrix as the values are loaded into
  ##   the uniform variable. Must be `GL_FALSE`.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniformMatrix3fv*(
  location: GlInt, count: GlSizei, transpose: GlBoolean, value: ptr GlFloat
) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of matrices that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array of matrices, and `1`
  ##   or more if it is an array of matrices.
  ## transpose
  ##   Specifies whether to transpose the matrix as the values are loaded into
  ##   the uniform variable. Must be `GL_FALSE`.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUniformMatrix4fv*(
  location: GlInt, count: GlSizei, transpose: GlBoolean, value: ptr GlFloat
) {.importc.}
  ## Specify the value of a uniform variable for the current program object.
  ##
  ## location
  ##   Specifies the location of the uniform value to be modified.
  ## count
  ##   Specifies the number of matrices that are to be modified. This should be
  ##   `1` if the targeted uniform variable is not an array of matrices, and `1`
  ##   or more if it is an array of matrices.
  ## transpose
  ##   Specifies whether to transpose the matrix as the values are loaded into
  ##   the uniform variable. Must be `GL_FALSE`.
  ## value
  ##   Specifies a pointer to an array of count values that will be used to
  ##   update the specified uniform variable.

proc glUseProgram*(program: GlUint) {.importc.}
  ## Install a program object as part of current rendering state.
  ##
  ## program
  ##   Specifies the handle of the program object whose executables are to be
  ##   used as part of current rendering state.

proc glValidateProgram*(program: GlUint) {.importc.}
  ## Validate a program object.
  ##
  ## program
  ##   Specifies the handle of the program object to be validated.

proc glVertexAttrib1f*(index: GlUint, x: GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified vertex attribute.

proc glVertexAttrib1fv*(index: GlUint, v: ptr GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v
  ##   Specifies a pointer to an array of values to be used for the generic
  ##   vertex attribute.

proc glVertexAttrib2f*(index: GlUint, x: GlFloat, y: GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified vertex attribute.

proc glVertexAttrib2fv*(index: GlUint, v: ptr GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v
  ##   Specifies a pointer to an array of values to be used for the generic
  ##   vertex attribute.

proc glVertexAttrib3f*(index: GlUint, x: GlFloat, y: GlFloat, z: GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified vertex attribute.

proc glVertexAttrib3fv*(index: GlUint, v: ptr GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v
  ##   Specifies a pointer to an array of values to be used for the generic
  ##   vertex attribute.

proc glVertexAttrib4f*(
  index: GlUint, x: GlFloat, y: GlFloat, z: GlFloat, w: GlFloat
) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v0, v1, v2, v3
  ##   Specifies the new values to be used for the specified vertex attribute.

proc glVertexAttrib4fv*(index: GlUint, v: ptr GlFloat) {.importc.}
  ## Specify the value of a generic vertex attribute.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## v
  ##   Specifies a pointer to an array of values to be used for the generic
  ##   vertex attribute.

proc glVertexAttribPointer*(
  index: GlUint,
  size: GlInt,
  `type`: GlEnum,
  normalized: GlBoolean,
  stride: GlSizei,
  pointer: pointer,
) {.importc.}
  ## Define an array of generic vertex attribute data.
  ##
  ## index
  ##   Specifies the index of the generic vertex attribute to be modified.
  ## size
  ##   Specifies the number of components per generic vertex attribute. Must be
  ##   `1`, `2`, `3`, or `4`. The initial value is `4`.
  ## type
  ##   Specifies the data type of each component in the array. Symbolic
  ##   constants `glByte`, `GL_UNSIGNED_BYTE`, `glShort`, `GL_UNSIGNED_SHORT`,
  ##   `cGL_FIXED`, or `cGL_FLOAT` are accepted. The initial value is
  ##   `cGL_FLOAT`.
  ## normalized
  ##   Specifies whether fixed-point data values should be normalized
  ##   (`GL_TRUE`) or converted directly as fixed-point values (`GL_FALSE`) when
  ##   they are accessed.
  ## stride
  ##   Specifies the byte offset between consecutive generic vertex attributes.
  ##   If `stride` is `0`, the generic vertex attributes are understood to be
  ##   tightly packed in the array. The initial value is `0`.
  ## pointer
  ##   Specifies a pointer to the first component of the first generic vertex
  ##   attribute in the array. The initial value is `0`.

proc glViewport*(x: GlInt, y: GlInt, width: GlSizei, height: GlSizei) {.importc.}
  ## Set the viewport.
  ##
  ## x, y
  ##   Specify the lower left corner of the viewport rectangle, in pixels. The
  ##   initial value is `(0,0)`.
  ## width, height
  ##   Specify the width and height of the viewport. When a GL context is first
  ##   attached to a window, `width` and `height` are set to the dimensions of
  ##   that window.
