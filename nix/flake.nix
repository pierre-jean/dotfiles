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
    (flake-utils.lib.eachDefaultSystem (
      system:
      import ./outputs.nix {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit system;
      }
    ))
    // {
      nixosConfigurations.slim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./machines/slim/configuration.nix ];
      };
    };
}
