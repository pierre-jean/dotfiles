
{ pkgs ? import <nixpkgs> {} }: with pkgs;
buildEnv {
  name = "cli-env";
  paths = [
    nix # If not on NixOS, this is important!
    nh

    nerdfonts.override { fonts = ["JetBrainsMono"]; };

    ### shells ###
    bash
    dash
    nushell
    zsh
    starship

    ### editors ###
    ed
    neovim
    kakoune
    helix

    ### utils ###
    coreutils
    tree
    ripgrep
    fzf
    xe
    xplr
    skim
    fd
    zoxide

    ### multiplexers ###
    tmux
    zellij

    ### files ###
    yazi
    xplr
    encfs
    sshfs
    udiskie

    ### media ###
    chafa
    libsixel
    mpv
    ffmpeg
    imagemagick
    yt-dlp
    yewtube

    ### network ###
    curl
    wget

    ### ai ###
    aichat

    ### mail ###
    aerc

    ### chat ###
    ii
    weechat

    ### browser ###
    w3m
    amfora

    ### bluetooth
    bluez
    bluez-tools
  ];
}
