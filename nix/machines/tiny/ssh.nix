{ ... }:
let perso = import ./perso.nix;
in {
  gitServer.enable = true;
  gitServer.authorizedKeys = perso.gitServer.authorizedKeys;
}
