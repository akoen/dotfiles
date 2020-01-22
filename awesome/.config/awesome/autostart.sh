#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# If you would like to run a command *once* on login,
# you can use ~/.xprofile

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Emacs daemon
#run emacs --daemon

# Load terminal colorscheme and settings
xrdb ~/.Xresources

# Insync
run insync

# Drobox
run dropbox

# Urxvt daemon
# run urxvtd -q -o -f

# Mpv input file
if [ ! -e /tmp/mpv.fifo ]; then
    mkfifo /tmp/mpv.fifo
fi

# Desktop effects
run picom --config ~/.config/picom/picom.conf

# Enable numlock on login
# Required numlockx to be installed
#run numlockx

# Network manager tray icon
run nm-applet

# Kill redshift processes
# pkill redshift

# Wallpaper
# (Already set to run in rc.lua)
# ~/.fehbg
