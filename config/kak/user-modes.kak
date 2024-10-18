declare-user-mode tmux  
map global tmux v ':tmux-terminal-vertical kak -c %val{session}<ret>'     -docstring 'Open Kak vertical pane'
map global tmux h ':tmux-terminal-horizontal kak -c %val{session}<ret>'     -docstring 'Open Kak horizontal pane'
map global tmux n ':tmux-terminal-window kak -c %val{session}<ret>'     -docstring 'Open Kak new window'

map global user t ':enter-user-mode tmux<ret>' 
