{ pkgs }: with pkgs;
buildEnv {
  name = "cli-base";
  paths = import ./cli-packages.nix { inherit pkgs; };
}
