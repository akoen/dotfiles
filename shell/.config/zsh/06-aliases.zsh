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

alias -g G='| grep' #now you can do: ls foo G something

o() {
    xdg-open "$1" &|
}

# Search for pkg in arch repositories and install it interactively.
alias pkgs="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"

# Make xclip use the primary selection
alias xclip="xclip -selection c"

alias nnn='NNN_FIFO="$(mktemp -u)" nnn'

alias doom='emacs --with-profile doom'

alias sysu='systemctl --user'
