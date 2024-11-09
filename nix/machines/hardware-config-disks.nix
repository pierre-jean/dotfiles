{ config, lib, pkgs, modulesPath, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."root-crypted".device =
    "/dev/disk/by-partlabel/root";

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/boot";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];
}
