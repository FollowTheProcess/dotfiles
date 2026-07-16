# Interactive shell config sourced by home-manager as programs.zsh.initContent.
# Most zsh config now lives in nix (nix/modules/home/programs/zsh.nix):

# https://github.com/michel-kraemer/zsh-patina
eval "$(zsh-patina activate)"

# zmv
autoload zmv

# Default WORDCHARS treats /, ., - as word chars so Alt+Backspace eats whole
# paths. Drop those (and a few others) so word-wise motion stops at them.
# shellcheck disable=SC2034 # It's a zsh config thing
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# Multi-stage matcher: exact -> case-insensitive -> substring -> partial-word.
# Each entry is tried in turn, so an exact match wins before fuzzier passes.
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|=*' \
    'l:|=* r:|=*'

# Group matches by type and label each group so completions are easier to scan
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'

# Colorise filename completions to match $LS_COLORS
# shellcheck disable=SC2296 # zsh-only parameter expansion flag, not bash
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Include dotfiles in completion matches by default
_comp_options+=(globdots)

# Richer process completion for `kill` (PID + user + command, colorised PIDs)
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=01;34=0=01'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:kill:*' force-list always

# Cache slow completions (eg. apt, brew search) to disk
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Key bindings
# Ctrl+X Ctrl+E to edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey ' ' magic-space
