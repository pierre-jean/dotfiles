# config.nu
#
# Installed by:
# version = "0.104.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.EDITOR = "hx"
$env.config.show_banner = false
source ~/.config/nushell/homebrew.nu
source ~/.config/nushell/mise.nu
# source ~/.config/nushell/direnv.nu
# source ~/.config/nushell/nuenv.nu # replace by mise
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/completions-jj.nu
source ~/.config/nushell/git.nu
source ~/.config/nushell/bitwarden.nu
source ~/.config/nushell/carapace.nu
source ~/.config/nushell/markdown-frontmatter.nu
source ~/.config/nushell/utils.nu
source ~/.config/nushell/sops.nu
source ~/.config/nushell/tasks.nu
source ~/.config/nushell/fzf.nu
#source ~/.config/nushell/todotxt.nu
