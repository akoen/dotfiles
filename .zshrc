# load configs
# for config (~/.config/zsh/*.zsh) source $config


# History
HISTFILE=~/Docs/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS

# Use vim keybdings
bindkey -v

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
alias spotify='spotify --force-device-scale-factor=2'
alias update='sudo pacman -Syu'
alias ls='ls --color=auto'
alias :q="exit"
alias cat='bat'
alias -g G='| grep' #now you can do: ls foo G something
alias pkgs="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias xclip="xclip -selection c"
alias nnn='NNN_FIFO="$(mktemp -u)" nnn'
alias doom='emacs --with-profile doom'
alias sysu='systemctl --user'
alias sudo='sudo ' # Support aliases with sudo
alias dc='docker compose'

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

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light jackharrisonsherlock/common
# zinit light dfurnes/purer
zinit light Aloxaf/fzf-tab
# zinit load wfxr/forgit

zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh

zinit ice depth=1

zinit light paulirish/git-open

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Completion (must be after zinit)
autoload -Uz compinit
compinit
