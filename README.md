## Dotfiles

You need to have `stow` installed.
First make sure you have downloaded the git submodules:
```
> git submodule init
> git submodule update
```

Then depending on the configuration you want, stow the right folders. For instance:
```
> stow -t $HOME openbsd
> cd base && stow -t $HOME *
```
you may need to relogin or resource your profile before running:
```
install-dotfiles
```
