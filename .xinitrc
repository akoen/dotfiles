[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Required for Flatpak to fix delay in gnome applications starting
#https://github.com/flatpak/xdg-desktop-portal-gtk/issues/72
# dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Run init scripts. See /etc/X11/xinit/xinitrc
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
# dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

exec bspwm
