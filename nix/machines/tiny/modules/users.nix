{ ... } :
let perso = import ../perso.nix;
infoToUser = i: {
    name = i.login;
    value = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = i.sshKeys;
    };
};
in
{
  users.users = builtins.listToAttrs (map infoToUser perso.users);
}
