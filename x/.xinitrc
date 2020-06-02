setxkbmap -option "caps:ctrl_modifier"
setxkbmap -option "shift:both_capslock"
xcape -e "Caps_Lock=Escape"

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xsetroot -cusor_name left_ptr # defaults to cross

exec bspwm

