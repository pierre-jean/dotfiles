{ config, lib, pkgs, modulesPath, ... }:

{
  programs.light.enable = true;
  services.xserver.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.gdm.wayland = true;
  programs.sway = {
	  enable = true;
	  wrapperFeatures.gtk = true;
  };
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.settings = {
	  #General = {
		 #DisplayServer="wayland";
	  #};
  #};
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true; # needed?
  boot.kernelParams = [ "quiet" ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  xdg.portal.wlr.enable = true;
  services.dbus.enable = true; # fix bug slow start of app https://www.reddit.com/r/NixOS/comments/s9ytrg/xdgdesktopportalwlr_on_sway_causes_20_seconds/
  services.dbus.implementation = "broker";
  hardware.pulseaudio.enable = false;
}
