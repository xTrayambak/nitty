type Platform* {.size: sizeof(uint8).} = enum
  Wayland = 0

func getPlatform*(): Platform {.compileTime.} =
  Platform.Wayland

func usingPlatform*(platform: Platform): bool {.compileTime.} =
  getPlatform() == platform
