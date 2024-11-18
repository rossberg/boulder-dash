{
  description = "OCaml Boulder Dash";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

        packages.default = pkgs.ocamlPackages.buildDunePackage {
          pname = "boulder_dash";
          version = "1.0.0";
          src = ../.;
          buildInputs = [ pkgs.ocamlPackages.graphics ];

          postInstall = ''
            ln -s ${../sprites.bmp} $out/bin/sprites.bmp
            mv $out/bin/boulderdash $out/bin/boulder_dash
          '';
        };

      };
      flake = {
      };
    };
}
