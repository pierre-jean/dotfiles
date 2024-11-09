{ pkgs, system, ... }:
let
  machines = [
    "slim"
    "metal"
  ];
in
{
  packages.default = pkgs.cowsay;
  packages.cli = import ./cli.nix { inherit pkgs; };
  packages.desktop = import ./desktop.nix { inherit pkgs; };
  # nixosConfigurations."${system}" = pkgs.lib.attrsets.attrByPath (machine: { "${machine}" = import ./nixosConfiguration.nix; });
 }
