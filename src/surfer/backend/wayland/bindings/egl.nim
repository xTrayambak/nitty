## Handrolled EGL bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import
  pkg/nayland/bindings/protocols/core,
  pkg/nayland/bindings/display,
  pkg/nayland/bindings/egl/[core, backend]

{.passC: "-DWL_EGL_PLATFORM".}

{.push header: "<EGL/egl.h>".}
type
  EGLBoolean* {.importc.} = bool
  EGLint* {.importc.} = int32

  EGLDisplay* {.importc.} = distinct pointer
  EGLConfig* {.importc.} = distinct pointer
  EGLSurface* {.importc.} = distinct pointer
  EGLContext* {.importc.} = distinct pointer

  EGLNativeDisplayType* {.importc.} = ptr wl_display
  EGLNativePixmapType* {.importc.} = pointer
    # TODO: I cannot find `wl_egl_pixmap` anywhere.
  EGLNativeWindowType* {.importc.} = ptr wl_egl_window

{.push importc.}
proc eglGetDisplay*(displayId: EGLNativeDisplayType): EGLDisplay
proc eglGetError*(): EGLint
proc eglGetProcAddress*(procname: cstring): pointer
proc eglInitialize*(disp: EGLDisplay, major, minor: ptr EGLint): EGLBoolean
proc eglGetConfigs*(
  disp: EGLDisplay, config: ptr EGLConfig, configSize: EGLint, numConfig: ptr EGLint
): EGLboolean

proc eglChooseConfig*(
  disp: EGLDisplay,
  attribList: ptr EGLint,
  configs: ptr EGLConfig,
  configSize: EGLint,
  numConfig: ptr EGLint,
): EGLBoolean

proc eglCreateWindowSurface*(
  disp: EGLDisplay, config: EGLConfig, win: EGLNativeWindowType, attribList: ptr EGLint
): EGLSurface

proc eglCreateContext*(
  disp: EGLDisplay, config: EGLConfig, shareCtx: EGLContext, attribList: ptr EGLint
): EGLContext

proc eglMakeCurrent*(
  disp: EGLDisplay, draw: EGLSurface, read: EGLSurface, ctx: EGLContext
): EGLBoolean

proc eglQueryString*(disp: EGLDisplay, name: EGLint): cstring
proc eglTerminate*(disp: EGLDisplay): EGLBoolean
proc eglSwapBuffers*(disp: EGLDisplay, surf: EGLSurface): EGLBoolean
proc eglWaitGL*(): EGLBoolean

let
  EGL_ALPHA_SIZE*: int32
  EGL_BAD_ACCESS*: int32
  EGL_BAD_ALLOC*: int32
  EGL_BAD_ATTRIBUTE*: int32
  EGL_BAD_CONFIG*: int32
  EGL_BAD_CONTEXT*: int32
  EGL_BAD_CURRENT_SURFACE*: int32
  EGL_BAD_DISPLAY*: int32
  EGL_BAD_MATCH*: int32
  EGL_BAD_NATIVE_PIXMAP*: int32
  EGL_BAD_NATIVE_WINDOW*: int32
  EGL_BAD_PARAMETER*: int32
  EGL_BAD_SURFACE*: int32
  EGL_BLUE_SIZE*: int32
  EGL_BUFFER_SIZE*: int32
  EGL_CONFIG_CAVEAT*: int32
  EGL_CONFIG_ID*: int32
  EGL_CORE_NATIVE_ENGINE*: int32
  EGL_DEPTH_SIZE*: int32
  EGL_DONT_CARE*: int32
  EGL_DRAW*: int32
  EGL_EXTENSIONS*: int32
  EGL_FALSE*: int32
  EGL_GREEN_SIZE*: int32
  EGL_HEIGHT*: int32
  EGL_LARGEST_PBUFFER*: int32
  EGL_LEVEL*: int32
  EGL_MAX_PBUFFER_HEIGHT*: int32
  EGL_MAX_PBUFFER_PIXELS*: int32
  EGL_MAX_PBUFFER_WIDTH*: int32
  EGL_NATIVE_RENDERABLE*: int32
  EGL_NATIVE_VISUAL_ID*: int32
  EGL_NATIVE_VISUAL_TYPE*: int32
  EGL_NONE*: int32
  EGL_NON_CONFORMANT_CONFIG*: int32
  EGL_NOT_INITIALIZED*: int32
  EGL_NO_CONTEXT*: int32
  EGL_NO_DISPLAY*: int32
  EGL_NO_SURFACE*: int32
  EGL_PBUFFER_BIT*: int32
  EGL_PIXMAP_BIT*: int32
  EGL_READ*: int32
  EGL_RED_SIZE*: int32
  EGL_SAMPLES*: int32
  EGL_SAMPLE_BUFFERS*: int32
  EGL_SLOW_CONFIG*: int32
  EGL_STENCIL_SIZE*: int32
  EGL_SUCCESS*: int32
  EGL_SURFACE_TYPE*: int32
  EGL_TRANSPARENT_BLUE_VALUE*: int32
  EGL_TRANSPARENT_GREEN_VALUE*: int32
  EGL_TRANSPARENT_RED_VALUE*: int32
  EGL_TRANSPARENT_RGB*: int32
  EGL_TRANSPARENT_TYPE*: int32
  EGL_TRUE*: int32
  EGL_VENDOR*: int32
  EGL_VERSION*: int32
  EGL_WIDTH*: int32
  EGL_WINDOW_BIT*: int32
{.pop.}
{.pop.}
