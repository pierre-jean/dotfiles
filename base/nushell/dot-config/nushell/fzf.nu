def fze [] {
  fd --type file | fzf --multi --preview 'bat {}' | xe -N0 $env.EDITOR 
}

def --env fzj [] {
  fd --type directory | fzf --preview 'tree -C {}' | cd $in
}
