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
    let machines = import ./machines.nix;
    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      import ./outputs.nix {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit system;
      }
    ))
    //
    { nixosConfigurations = (builtins.mapAttrs (host: system:  nixpkgs.lib.nixosSystem { inherit system; pkgs = nixpkgs.legacyPackages.${system}; modules = [ ./machines/${host}/configuration.nix ]; }) machines );};
}
