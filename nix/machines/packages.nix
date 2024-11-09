{ pkgs, ... }:

{
  #nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ kakoune coreutils ];

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
  # system = {
      # autoUpgrade = {
          # enable = true;
          # flake = "gitlab:fladnix/machines";
          # dates = "daily";
          # flags = [
              # "--recreate-lock-file"
              # "--no-write-lock-file"
              # "-L" # print build logs
          # ];
      # };
  # };
}
