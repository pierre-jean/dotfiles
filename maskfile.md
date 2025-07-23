# Environment management

## install

```sh
mask install all
```

### install all

```sh
mask install fonts
mask install config
mask install apps
mask install secrets
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

### install config

First, we need to create our gits folders so that stow only link files individually instead of linking the whole folder:

```sh
mkdir -p $HOME/gits/{epic,pierre-jean}/.todelete
```

Then we backup existing files for bash and zsh installed with our distro:

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

Finally, we use stow to deploy our config files as symlinks:
  
```sh
cd base
stow --target=$HOME --dotfiles *
cd -
  
```

### install apps

Install dependencies for homebrew:
```sh
sudo apt install curl git
```

Then install homebrew:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install all apps in our [Brewfile](./Brewfile):
```sh
  brew bundle install
```

### install secrets

Recreate the key from the password manager:
```sh
mkdir -p $HOME/.config/mise
echo "# public key: $(rbw get --field username 'Age key')" > $HOME/.config/mise/age.txt
echo "$(rbw get --field password 'Age key')" >> $HOME/.config/mise/age.txt
```
  
Put it in the default folder for both Mise and Sops so that we can use SOPs (`sops encrypt -i file` and `sops decrypt -i file`) without defining the placement of the key.
```sh
mkdir -p $HOME/.config/sops/age
cp $HOME/.config/mise/age.txt $HOME/.config/sops/age/keys.txt
```

### install ssh

```sh
ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N ""
cd $HOME/gits/pierre-jean/
gh ssh-key add $HOME/.ssh/id_ed25519.pub
```

### install encrypted-files

For git:
```bash
mkdir -p $HOME/.config/git/decrypted
for f in $HOME/.config/git/crypted/*
do
  filename="$(basename $f)" 
  sops decrypt "$f" > "$HOME/.config/git/decrypted/$filename" 
done  
```
