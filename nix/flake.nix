{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    ### packages pack to install as profiles on any nix machine
    (flake-utils.lib.eachDefaultSystem (
      system:
      import ./outputs.nix {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit system;
      }
    ))
    ### nixos configurations for all my nixos machines
    // {
      nixosConfigurations = (
        builtins.mapAttrs (
          host: system:
          nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./machines/${host}/configuration.nix ];
          }
        ) (import ./machines.nix)
      );
    };
}
