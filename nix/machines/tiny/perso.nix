let
  pjPerso = {
    login = "animus";
    email = "pierre-jean@baraud.fr";
    fullname = "Pierre-Jean Baraud";
    sshKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYvzV22tpaaws0ntykLhEr5ryfkdCQIUCtWf3gtjot0BbvnjuYaPUoYWMGTYzZ3uRaOZIE3FjYF4Tw+w3xl1Bd3S+/9MADM+pTeHuLRa3yVrEFnZj0UETFsqepL3lJ70U9B/UPYMXMKuUp8+h2NVLTR5RBB9DDdOBtlDxQ6Lwwa4cB5PPNUuDXXC7YPYVaZDdRnG1dgiHpS1BjCEJpQQK8k7kRF++LX8VmQx0ryX+g1ChlIy18/ewYIe1cClb5BTpkS8WR7hTtieSwK3Derdq1V8CUf3Ieo8DCyDhO+nhEDtG+Oh3oLi9VCWOmNQbKIrJ99qKWhyUPmy0ysufMfx34pxu8IIPBxkEexHoFz2dfFt198+IBsP9Ckw0fWwqo4a1QY5KduWZAkZpYTRgJeyZa0u4wVTSPV2lhDIRQu+vM/R096xQRzbLKlN3WVAn0nYzGV6sodzkHx7ejf1tQhCiLG9iyg80xJvvNq/DiRqSRqJNW+H2ppA2z0j0lXOqoEh8= animus@slim"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB9ZRvK30xNu5Z1It9eB890DI/KrY9fNW4mfju5kwjROAAAABHNzaDo= animus@nixos"
    ];
  };
  pjCommunity = {
    login = "indy";
    email = "indy@yabage.me";
    fullname = "Indiana Codes";
    sshKeys = [ ];
  };
  fuen = {
    login = "lafuenka";
    email = "lafuenka@hotmail.com";
    fullname = "Fuensanta Zambrana Ruiz";
    sshKeys = [ ];
  };
in {
  users = [ pjPerso pjCommunity fuen ];
  gitServer.authorizedKeys = pjPerso.sshKeys;
}
