## Aliases
# Set vim to neovim
alias vim='nvim'

# Force device scaling on spotify
alias spotify='spotify --force-device-scale-factor=2'

# Start spotifyd with spt
alias spt='spotifyd &; spt'

# Doom Emacs
alias doom="emacs -q --load '~/.doom/init.el'"

# Update system
alias update='sudo pacman -Syu'

# ls with color
alias ls='ls --color=auto'

# Because vim is good
alias :q="exit"

alias -g G='| grep' #now you can do: ls foo G something

# Make xclip use the primary selection
alias xclip="xclip -selection c"
