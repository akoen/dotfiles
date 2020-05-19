# Use emacs keybdings
bindkey -e

# Set shift to capslock system-wide
setxkbmap -option "caps:ctrl_modifier"
setxkbmap -option "shift:both_capslock"
xcape -e "Caps_Lock=Escape"

# press Ctrl-z to return to vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
