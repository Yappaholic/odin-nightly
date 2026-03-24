{
  description = "Nightly Odin packages";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    odin-src = {
      url = "github:odin-lang/Odin";
      flake = false;
    };
    ols-src = {
      url = "github:DanielGavin/ols";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        odin-nightly = pkgs.callPackage ./pkgs/odin-nightly.nix {inherit inputs;};
        ols-nightly = pkgs.callPackage ./pkgs/ols.nix {
          inherit inputs;
          inherit odin-nightly;
        };
        devShell = pkgs.callPackage ./pkgs/shell.nix {inherit pkgs;};
      in {
        overlayAttrs = {
          inherit (config.packages) ols;
          odin = config.packages.odin-nightly;
        };
        packages = {
          inherit odin-nightly;
          default = odin-nightly;
          ols = ols-nightly;
        };
        apps.updater = pkgs.runCommand "update.sh" {} ''
          nix flake update odin-src
          nix flake update ols-src
          git add .
          git commit -m "update sources $(date)"
        '';
        devShells.default = devShell;
      };
      flake = {
      };
    };
}
