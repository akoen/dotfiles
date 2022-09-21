# load configs
for config (~/.config/zsh/*.zsh) source $config

# The next line updates PATH for Netlify's Git Credential Helper.
test -f '/home/alex/.config/netlify/helper/path.zsh.inc' && source '/home/alex/.config/netlify/helper/path.zsh.inc'