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
mask install env
mask install secrets
mask install ssh
```

### install fonts

This installed Jetbrains font for the local user:
```bash
mkdir -p ~/.local/share/fonts
if [[ $(fc-list : family | grep -w -q "JetBrainsMono Nerd Font") ]];
then
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
fi
```

### install apps

This will install all global applications via [Homebrew](https://brew.sh/)

```sh
if ! [ -x "$(command -v foo)" ];
then
  sudo apt install curl git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle install
```

### install config

First, we backup existing files for bash and zsh installed with our distro:
Then, we need to create folders that will receive files from stow and that we don't want to be symlinks as folders:
Finally, we use stow to deploy our config files as symlinks:
```bash
if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]];
then
  mv "$HOME/.bashrc" "$HOME/.bashrc.bk"
fi
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]];
then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bk"
fi
if [[ -f "$HOME/.zprofile" && ! -L "$HOME/.zprofile" ]];
then
  mv "$HOME/.zprofile" "$HOME/.zprofile.bk"
fi
if [[ -f "$HOME/.profile" && ! -L "$HOME/.profile" ]];
then
  mv "$HOME/.profile" "$HOME/.profile.bk"
fi
mkdir -p $HOME/gits/{epic,pierre-jean}/.todelete
cd base
stow --target=$HOME --dotfiles *
cd -
rm -r $HOME/gits/{epic,pierre-jean}/.todelete
```

### install env

```bash
cd $HOME
fd "mise.toml" | xargs -L 1 mise trust
```

### install secrets

Recreate the key from the password manager:
```bash
mkdir -p $HOME/.config/mise
echo "# public key: $(rbw get --field username 'Age key')" > $HOME/.config/mise/age.txt
echo "$(rbw get --field password 'Age key')" >> $HOME/.config/mise/age.txt
# Put it in the default folder for both Mise and Sops so that we can use Sops without defining the placement of the key (`sops encrypt -i file` and `sops decrypt -i file`).
mkdir -p $HOME/.config/sops/age
cp $HOME/.config/mise/age.txt $HOME/.config/sops/age/keys.txt
# Uncrypt git secrets:
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
if [ ! -f $HOME/.ssh/id_ed25519 ];
then
ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N ""
fi
if [ ! -f $HOME/.ssh/id_epic_ed25519 ];
then
ssh-keygen -t ed25519 -f $HOME/.ssh/id_epic_ed25519 -N "" -C "$(git config -f $HOME/.config/git/decrypted/epic.gitconfig user.email)"
fi
# And deploy it on github (the token and variables are different depending on the folder so it will point to different github instances):
cd ~/gits/pierre-jean
gh ssh-key add ~/.ssh/id_ed25519.pub
cd ~/gits/epic
gh ssh-key add ~/.ssh/id_epic_ed25519.pub
git remote set-url origin git@github.com:pierre-jean/dotfiles.git
```
