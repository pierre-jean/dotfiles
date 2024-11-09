{ pkgs, ... }: {
  users.users.animus = {
    isNormalUser = true;
    description = "Pierre-Jean Baraud";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "users"
      "libvirtd"
      "docker"
      "fuse"
    ];
    packages = with pkgs; [ ];
  };
  users.users.fuen = {
    isNormalUser = true;
    description = "Fuensanta Zambrana Ruiz";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "users"
      "libvirtd"
      "docker"
      "fuse"
    ];
    packages = with pkgs; [ ];
  };
}
