{ ... }: {
  remoteLuksUnlock.enable = true;
  remoteLuksUnlock.ssh.port = 2222;
  remoteLuksUnlock.authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB9ZRvK30xNu5Z1It9eB890DI/KrY9fNW4mfju5kwjROAAAABHNzaDo= animus@nixos"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcjvjg0eyYarbCwaFQaINhbyRoK8QHIh+aGLsQMtPY5JPsy++rcxsq7WZwFCVLmAYHwz8Yj8CzYtwj2YtyrcO7GE62YTcMTD+oJaPyV6ancYAh5aXV0wncR7AYo7tWNiSnloKJl7vL/c1DJEzUpt6jBEhyktID+V4+UpZ6Y9vPqQGk5xGeKKHPRKXHQ7Ygl7GUSpXq7zFdBiIfxF4VqVuXuv/BzdKh9dxhgHeGZ/uLWnbtMY7vQQY1ZXmDA8P2Gpwtjx0uM09KMgvE1xbZ/8fv+7p4Jcy0itgsIEcfHmCo3N06/urn8wjUXNk58DNl2W4qNqLOybUSutTFsF3+OUS9sor0QypeCpD7U3ztE0I5phbvII42bs9s6501wv8v8SjOXJ6B6pjMbpS9RwGzSogic+0hAnnbqfZXAq58R2108oVPJlnAv6bGBiWrZhHtV25lM/XUt7Bb9jd+2EC92yyrmD7Dypuk1P8qq1/F5Y4xQLsmyHuIzcVdELOEsr8U6Zk= animus@slim"
  ];
  remoteLuksUnlock.luksVolume = 
    "/dev/disk/by-partlabel/root";
  # This need to be generated before!
  # See https://nixos.wiki/wiki/Remote_LUKS_Unlocking
  # `ssh-keygen -t rsa -N "" -f /etc/secrets/initrd/ssh_host_rsa_key`
  remoteLuksUnlock.hostKeys = [ "/secrets/initrd/ssh_host_rsa_key" ];
}
