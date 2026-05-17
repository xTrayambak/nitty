{
  description = "A high-performance, GPU-accelerated terminal emulator written in Nim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nim2nix.url = "github:daylinmorgan/nim2nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nim2nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nim2nix.overlays.default ];
        };
        version = "0.2.2";
      in
      {
        packages.default = pkgs.buildNimblePackage {
          pname = "nitty";
          version = version;
          src = ./.;

          buildInputs = with pkgs; [
            libvterm-neovim
            wayland
            libxkbcommon
            fontconfig
            simdutf
            libGL
          ];

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          nimbleLockFile = ./nimble.lock;
          nimbleDepsHash = "sha256-2YBZB5j5V24cDXzFK17TOw2wxa4SxwOHmwXRKBImpO8=";

          nimFlags = [
            "--define:release"
            "--opt:speed"
            "--define:lto"
            "--define:NimblePkgVersion=${version}"
          ];

          meta = with pkgs.lib; {
            description = "A high-performance, GPU-accelerated terminal emulator written in Nim";
            platforms = platforms.linux;
            license = licenses.bsd3;
          };

          doCheck = false;
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            self.packages.${system}.default.buildInputs
            ++ (with pkgs; [
              nim
              nimble
              pkg-config
            ]);
        };
      }
    );
}
