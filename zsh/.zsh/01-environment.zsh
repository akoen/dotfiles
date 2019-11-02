# environment variables
export EDITOR='nvim'
export PATH=$HOME/bin:$PATH
export MOZ_USE_XINPUT2=1
export GDk_SCALE=2

# Android studio
export ANDROID_HOME=~/Android/
export PATH=$PATH:~/Android/platform-tools/
export PATH=$PATH:~/Android/tools
export PATH=$PATH:~/Android/build-tools/29.0.2/

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
