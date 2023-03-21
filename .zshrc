# Enable Powerlevel10k instant propt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# History
HISTFILE=~/Docs/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS

# Use vi keybdings
bindkey -e

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

# ALIASES
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='nvim'
alias update='sudo pacman -Syu'
alias ls='ls --color=auto'
alias :q="exit"
alias cat='bat'
alias -g G='| rg' #now you can do: ls foo G something
alias pkgs="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias xclip="xclip -selection c"
alias nnn='NNN_FIFO="$(mktemp -u)" nnn'
alias doom='emacs --with-profile doom'
alias sysu='systemctl --user'
alias sudo='sudo ' # Support aliases with sudo
alias dc='docker compose'
alias td="todoist-cli --color"
alias tds='td sync'
alias tdt='td l --filter "(today | overdue)"'

setopt auto_pushd
alias cdd='dirs -v && read index && let "index=$index+0" && cd ~"$index" && let "index=$index+1" && popd -q +"$index"'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

g() {
  if [ $# -eq 0 ]; then
    git status -sb
  else
    git "$@"
  fi
}

mcd() { mkdir -p "$1" && cd "$1"; }

# DIRENV
eval "$(direnv hook zsh)"

# FUNCTIONS

o() {
    xdg-open "$1" &|
}

onmodify() {
    TARGET=${1:-.}; shift
    CMD="$@"

    echo "$TARGET" "$CMD"
    while inotifywait --exclude '.git' -qq -r -e close_write,moved_to,move_self $TARGET; do
        sleep 0.2
        bash -c "$CMD"
        echo
    done
}

cmath(){
    xclip -o | sed 's/<math>/ \\(/g;  s/<\/math>/\\) /g' | xclip -i
    xclip -o | sed 's/\$/\\(/; s/\$/\\)/' | xclip -i
}

function get_xrdb() {
  xrdb -query | grep "$1" | awk '{print $2}' | tail -n1
}

# FZF
export FZF_DEFAULT_COMMAND='fd --full-path -t f --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --full-path -t d"

# Source fzf keybindings
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# PYENV

# See also exports in .zprofile
# eval "$(pyenv init -)"

# Todoist
TD_CMD="todoist-cli --color"

_todoist_fzf() {
    fzf --ansi --layout=reverse --multi --min-height=20 --border \
    --color='header:italic:underline' \
    --preview-window='bottom,20%,border-top' \
    --preview "$TD_CMD show {1}" \
    --bind "enter:become($TD_CMD modify {1})" \
    --bind "alt-enter:execute($TD_CMD close {1})" \

}

t() {
  todoist-cli --color list | _todoist_fzf
}

tdw() {
  td l --filter "due before: $(date '+%d/%m/%Y' -d '+1 week')" | _todoist_fzf
}


ZSH_PLUGIN_DIR=/home/alex/.config/zsh/plugins

source $ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZSH_PLUGIN_DIR/.p10k.zsh ]] || source $ZSH_PLUGIN_DIR/.p10k.zsh

# Git integration
source $ZSH_PLUGIN_DIR/fzf-git/fzf-git.sh
gco() {
  local selected=$(_fzf_git_each_ref --no-multi)
  [ -n "$selected" ] && git switch "$selected"
}

source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH_PLUGIN_DIR/zsh-z/zsh-z.plugin.zsh

# echo -ne '\e[5 q'

function zle-keymap-select () {
    # Only supported in these terminals
    if [ "$TERM" = "xterm-256color" ] || [ "$TERM" = "xterm-kitty" ] || [ "$TERM" = "screen-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            # Set block cursor
            echo -ne '\e[1 q'
        else
            # Set beam cursor
            echo -ne '\e[5 q'
        fi
    fi

    # if typeset -f prompt_pure_update_vim_prompt_widget > /dev/null; then
    #     # Refresh prompt and call Pure super function
    #     prompt_pure_update_vim_prompt_widget
    # fi
}

# Bind the callback
zle -N zle-keymap-select


bindkey -M vicmd _ insert-last-word

# Reduce latency when pressing <Esc>
export KEYTIMEOUT=1

# Completion (must be at end)
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # small letters match capital letters
