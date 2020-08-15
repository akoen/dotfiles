# ~/.zprofile - for setting commands and variables that do not need to be changed often. Read at login. Changes will require a session restart.

export EDITOR="nvim"
export FILE="nnn"
export GUI_FILE="nemo"
export TERMINAL="tilix"

# Display scaling
# From https://forum.archlabslinux.com/t/solved-4k-monitor-dpi-scaling/3191/7
export GDK_SCALE=2			# UI scale
export GDK_DPI_SCALE=0.5		# Text scale
export QT_AUTO_SCREEN_SCALE_FACTOR=1  # can cause issues with text size

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

# LaTeX
export TEXMFHOME=$HOME/.texmf

# nnn
export NNN_PLUG='p:preview-tabbed'

exec startx -- -dpi 144