{ config, lib, pkgs, modulesPath, ... }: {
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/sbin/modprobe -r e1000e
    ${pkgs.iproute2}/sbin/ip link set down enp0s31f6
  '';

  powerManagement.powerUpCommands = ''
    ${pkgs.kmod}/sbin/modprobe e1000e
    ${pkgs.iproute2}/sbin/ip link set up enp0s31f6
  '';

  boot.kernelParams = [ "mem_sleep_default=deep" ];
}
