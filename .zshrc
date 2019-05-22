# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/alex/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.antigen.zsh

# Load the oh-my-zsh library.
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle common-aliases

# Other bundles
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
#antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship
antigen theme https://github.com/jackharrisonsherlock/common common

# Tell Antigen that you're done
antigen apply

# Setup autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## Aliases
# Set vim to neovim
alias vim='nvim'

# Force device scaling on spotify
alias spotify='spotify --force-device-scale-factor=2'

# Update system
alias update='sudo pacman -Syu'

# ls with color
alias ls='ls --color=auto'

# Because vim is good
alias :q="exit"

# environment variables
export EDITOR='nvim'
export MOZ_USE_XINPUT2=1
export GDk_SCALE=2

alias -g G='| grep' #now you can do: ls foo G something

# Use fzf with rg
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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

# Autocomplete base16 commands
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

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
