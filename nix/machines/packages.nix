{ pkgs, ... }:

{
  #nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (import ../cli-packages.nix { inherit pkgs; }) ++ (import ../desktop-packages.nix { inherit pkgs; } ) ;

  nix = {
      settings.experimental-features = ["nix-command flakes"];
      settings.auto-optimise-store = true;
      gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
      };
      optimise = {
          automatic = true;
          dates = [ "weekly" ];
      };
  };
}
