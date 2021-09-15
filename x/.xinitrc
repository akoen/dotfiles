# setxkbmap -option "caps:ctrl_modifier"
# setxkbmap -option "shift:both_capslock"
# xcape -e "Caps_Lock=Escape"

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Gnome keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# Required for Flatpak to fix delay in gnome applications starting
#https://github.com/flatpak/xdg-desktop-portal-gtk/issues/72
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

exec bspwm
# exec xmonad
# exec sway
