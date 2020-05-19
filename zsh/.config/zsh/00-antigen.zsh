export ADOTDIR=$HOME/.local/share/antigen

# Source antigen, installed locally
source ~/.config/zsh/antigen.zsh

# Load the oh-my-zsh library.
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle git
antigen bundle command-not-found

# Other bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme
#antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship
antigen theme https://github.com/jackharrisonsherlock/common common

# Tell Antigen that you're done
antigen apply
