# environment variables
export DISPLAY=:0

# Cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

export EDITOR='nvim'

export PATH=$HOME/bin:$PATH
# export MOZ_USE_XINPUT2=1
# export GDk_SCALE=2

# Android studio
# export ANDROID_HOME=~/Android/
# export PATH=$PATH:~/Android/emulator/
# export PATH=$PATH:~/Android/platform-tools/
# export PATH=$PATH:~/Android/tools
# export PATH=$PATH:~/Android/build-tools/29.0.2/

export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
# Fixes blank screen when using bspwm
export _JAVA_AWT_WM_NONREPARENTING=1

# Python
export PATH=$PATH:~/.local/bin/

# LaTeX
export TEXMFHOME=$HOME/.texmf

# C Compiler
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# Use all cores for makepkg
# https://wiki.archlinux.org/index.php/Makepkg#Improving_compile_times
export MAKEFLAGS="-j$(nproc)"

