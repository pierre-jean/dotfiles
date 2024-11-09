# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let secrets = import ./secrets.nix;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/users.nix
  ];

  gitServer.enable = true;
  gitServer.authorizedKeys = secrets.gitServer.authorizedKeys;
  remoteLuksUnlock.enable = true;
  remoteLuksUnlock.ssh.port = 2222;
  remoteLuksUnlock.authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB9ZRvK30xNu5Z1It9eB890DI/KrY9fNW4mfju5kwjROAAAABHNzaDo= animus@nixos"
  ];
  remoteLuksUnlock.luksVolume =
    "/dev/disk/by-uuid/82ca39ec-640a-4471-b451-7a605c06fd85";
  remoteLuksUnlock.hostKeys = [ "/secrets/initrd/ssh_host_rsa_key" ];

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tiny"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ kakoune ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

