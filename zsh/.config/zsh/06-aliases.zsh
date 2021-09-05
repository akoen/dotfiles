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

## Photos
alias image='feh -g 640x480 --scale-down --auto-rotate --start-at'
alias elodie='~/.local/bin/elodie/elodie.py'
alias pi='elodie import --debug --destination="~/Pictures/Elodie"'
alias ph+='exiftool -AllDates+=1'
alias ph-='exiftool -AllDates-=1'
alias pu='elodie update --debug'

pua() {
    elodie update --album="$1" ${@:2}
}

pu-7() {
    for file in "$@"
    do
        echo $FILE | grep -o -P "(?<=/)\d*-\d*-\d*_\d*-\d*-\d*" 
    done
}

# Does not work
# put() {
#     ~/Downloads/elodie/elodie.py update --debug --time="$(date -d "$(xclip -o | sed 's/,//g')" '+%F %T')"
# }

