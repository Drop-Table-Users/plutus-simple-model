{
  description = "plutus-simple-model";

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
    extra-substituters = [ "https://cache.iog.io" "https://cache.zw3rk.com" ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
    ];
    allow-import-from-derivation = "true";
    max-jobs = "auto";
    auto-optimise-store = "true";
  };

  inputs = {
    nixpkgs.follows = "liqwid-nix/nixpkgs";
    nixpkgs-latest.url = "github:NixOS/nixpkgs";
    liqwid-nix = {
      url = "github:Liqwid-Labs/liqwid-nix/v2.9.2";
      inputs.nixpkgs-latest.follows = "nixpkgs-latest";
    };
    liqwid-libs.url =
      "github:Liqwid-Labs/liqwid-libs";
    cardano-base.url = "github:input-output-hk/cardano-base/cardano-strict-containers-0.1.1.0";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.liqwid-nix.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          pkgs = import inputs.nixpkgs-latest { inherit system; };
        in
        {
          # See: https://liqwid-labs.github.io/liqwid-nix/reference/modules.html
          onchain.default = {
            src = ./.;
            ghc.version = "ghc925";
            fourmolu.package = pkgs.haskellPackages.fourmolu;
            hlint = { };
            cabalFmt = { };
            hasktags = { };
            applyRefact = { };
            shell = { };
            hoogleImage.enable = false;
            enableCabalFormatCheck = true;
            enableHaskellFormatCheck = true;
            enableBuildChecks = true;
            extraHackageDeps = [
              "${inputs.cardano-base}/cardano-strict-containers"
            ];
          };
        };
    };
}
