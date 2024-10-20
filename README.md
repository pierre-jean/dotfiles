## Dotfiles

You need to have `stow` installed.
How to run on OpenBSD:

```
> stow -t $HOME openbsd
> cd base && stow -t $HOME *
```
you may need to relogin or resource your profile before running:
```
install-dotfiles
```
