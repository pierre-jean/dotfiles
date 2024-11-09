{ pkgs }: with pkgs;
buildEnv {
  name = "desktop-base";
  paths = import ./desktop-packages.nix { inherit pkgs; };
}
