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
          version = "2.0.4";
          src = ../../.;
          buildInputs = [ pkgs.ocamlPackages.graphics ];

          postInstall = ''
            mv $out/bin/boulderdash_graphics $out/bin/boulder_dash 
            ln -s ${../../assets} $out/bin/assets
          '';
        };

      };
      flake = {
      };
    };
}
