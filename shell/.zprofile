# ~/.zprofile - for setting commands and variables that do not need to be changed often. Read at login. Changes will require a session restart.

export EDITOR="emacsclient -nc"
export FILE="nnn"
export GUI_FILE="nemo"
export TERMINAL="alacritty"

# Wayland and sway
# export MOZ_ENABLE_WAYLAND=1
# export XDG_CURRENT_DESKTOP=sway

# Display scaling
# From https://forum.archlabslinux.com/t/solved-4k-monitor-dpi-scaling/3191/7
if [ $(hostname) = falcon ]; then
    export GDK_SCALE=2			# UI scale
    export GDK_DPI_SCALE=0.5		# Text scale
    export QT_AUTO_SCREEN_SCALE_FACTOR=1  # can cause issues with text size
fi

# export QT_QPA_PLATFORMTHEME="qt5ct"

# Multi-monitor setup
if [ $(hostname) = egret ]; then
    # xrandr --output DP-2 --auto --output HDMI-1 --auto --right-of DP-2
fi

# Cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

export PATH=$HOME/bin:$PATH
export MOZ_USE_XINPUT2=1

export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
# Fixes blank screen when using bspwm
export _JAVA_AWT_WM_NONREPARENTING=1

# C Compiler
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# Use all cores for makepkg
# https://wiki.archlinux.org/index.php/Makepkg#Improving_compile_times
export MAKEFLAGS="-j$(nproc)"

# Python
export PATH=$PATH:~/.local/bin
# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# LaTeX
export TEXMFHOME=$HOME/.texmf

# nnn
export NNN_PLUG='p:preview-tabbed'

# npm
export npm_config_prefix="$HOME/.local"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    # exec startx -- -dpi 144
    source $HOME/.config/wayland-setup
    systemd-cat --identifier=river river $@
fi
