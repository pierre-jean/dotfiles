# $OpenBSD: dot.profile,v 1.8 2022/08/10 07:40:37 tb Exp $
#
# sh/ksh initialization

PATH=$HOME/bin:$HOME/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
export PATH HOME TERM
ENV=.config/ksh/kshrc
export ENV
. $HOME/.personal

# Locale
LC_ALL=en_GB.UTF-8
export LC_ALL

# tmux
TERM=tmux-256color
TMUX_PLUGIN_MANAGER_PATH=$HOME/.config/tmux/plugins
export TERM TMUX_PLUGIN_MANAGER_PATH