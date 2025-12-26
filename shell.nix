with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    pkg-config
    c2nim
    wayland
    libxkbcommon
    wayland-scanner
    libvterm-neovim
    fontconfig
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    wayland.dev
    libxkbcommon.dev
    libvterm-neovim
    fontconfig.dev
  ];
}
