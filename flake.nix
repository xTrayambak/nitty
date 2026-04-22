{
  description = "A high-performance, GPU-accelerated terminal emulator written in Nim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildNimPackage {
          pname = "nitty";
          version = "0.1.0";
          src = ./.;

          buildInputs = with pkgs; [
            libvterm-neovim
            wayland
            libxkbcommon
            fontconfig
            libGL
          ];

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          nimFlags = [
            "--define:release"
            "--opt:speed"
            "--define:lto"
          ];

          meta = with pkgs.lib; {
            description = "A high-performance, GPU-accelerated terminal emulator written in Nim";
            platforms = platforms.linux;
            license = licenses.bsd3;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            self.packages.${system}.default.buildInputs
            ++ (with pkgs; [
              nim
              nimble
            ]);
        };
      }
    );
}
