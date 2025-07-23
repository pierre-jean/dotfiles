# Environment management

This document defines the different steps to redeploy my environment.
You can follow the steps below, or use [mask](https://github.com/jacobdeichert/mask) (once installed) to run the different secions as commands.

## install

> This will install all in the right order for you, assuming a fresh ubuntu OS

```sh
mask install all
```

### install all

```sh
mask install fonts
mask install apps
mask install config
mask install secrets
mask install ssh
```

### install fonts

This installed Jetbrains font for the local user:
```sh
mkdir -p ~/.local/share/fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
  
```

### install apps

This will install all global applications via [Homebrew](https://brew.sh/)

* First, Install dependencies for homebrew:
```sh
sudo apt install curl git
```

* Then install homebrew itself:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

* Finally, install all apps listed in the [Brewfile](./Brewfile):
```sh
  brew bundle install
```

### install config

First, we backup existing files for bash and zsh installed with our distro:
```sh
if [ -f "$HOME/.bashrc" ];
then
  mv "$HOME/.bashrc" "$HOME/.bashrc.bk"
fi
if [ -f "$HOME/.zshrc" ];
then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bk"
fi
if [ -f "$HOME/.zprofile" ];
then
  mv "$HOME/.zprofile" "$HOME/.zprofile.bk"
fi
if [ -f "$HOME/.profile" ];
then
  mv "$HOME/.profile" "$HOME/.profile.bk"
fi
```

Then, we need to create folders that will receive files from stow and that we don't want to be symlinks as folders:
```sh
mkdir -p $HOME/gits/{epic,pierre-jean}/.todelete
```

Finally, we use stow to deploy our config files as symlinks:
```sh
cd base
stow --target=$HOME --dotfiles *
cd -
```

### install secrets

Recreate the key from the password manager:
```sh
mkdir -p $HOME/.config/mise
echo "# public key: $(rbw get --field username 'Age key')" > $HOME/.config/mise/age.txt
echo "$(rbw get --field password 'Age key')" >> $HOME/.config/mise/age.txt
```
  
Put it in the default folder for both Mise and Sops so that we can use Sops without defining the placement of the key (`sops encrypt -i file` and `sops decrypt -i file`).
```sh
mkdir -p $HOME/.config/sops/age
cp $HOME/.config/mise/age.txt $HOME/.config/sops/age/keys.txt
```

Uncrypt git secrets:
```bash
mkdir -p $HOME/.config/git/decrypted
for f in $HOME/.config/git/crypted/*
do
  filename="$(basename $f)" 
  sops decrypt "$f" > "$HOME/.config/git/decrypted/$filename" 
done  
```

### install ssh

Generate new keys for personal and work use
```sh
ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N ""
ssh-keygen -t ed25519 -f $HOME/.ssh/id_epic_ed25519 -N "" -C "$(git config -f $HOME/.config/git/decrypted/epic.gitconfig user.email)"
```

And deploy it on github (the token and variables are different depending on the folder so it will point to different github instances):
```sh
cd ~/gits/pierre-jean
gh ssh-key add ~/.ssh/id_ed25519.pub
cd ~/gits/epic
gh ssh-key add ~/.ssh/id_epic_ed25519.pub
```
