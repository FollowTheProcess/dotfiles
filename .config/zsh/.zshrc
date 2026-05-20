# Make sure XDG dirs we write to exist on a fresh machine
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
[[ -d $XDG_STATE_HOME/zsh ]] || mkdir -p "$XDG_STATE_HOME/zsh"

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
# shellcheck disable=SC2034 # It's a zsh config thing
SAVEHIST=$HISTSIZE
# shellcheck disable=SC2034 # It's a zsh config thing
HISTDUP=erase

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# Shell behaviour
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt NOBEEP
setopt NUMERIC_GLOB_SORT # Sort file10 after file9, not after file1
setopt EXTENDED_GLOB     # Enable ^pattern, ~exclude, (#i) case-insensitive, etc.
setopt INTERACTIVE_COMMENTS
setopt GLOB_DOTS       # globs match dotfiles too (think `rm *`)
setopt MULTIOS         # `cmd >a >b` writes to both
setopt LONG_LIST_JOBS  # `jobs` shows PID
setopt NOTIFY          # report job status immediately, not at next prompt
setopt NO_FLOW_CONTROL # frees Ctrl-S / Ctrl-Q (also `stty -ixon`)
setopt RC_QUOTES       # 'it''s' parses as "it's"

# zmv
autoload zmv

# Default WORDCHARS treats /, ., - as word chars so Alt+Backspace eats whole
# paths. Drop those (and a few others) so word-wise motion stops at them.
# shellcheck disable=SC2034 # It's a zsh config thing
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Custom functions live in $ZDOTDIR/functions/ - one function per file, named
# after the function itself. Added to fpath and autoloaded below. Glob flags:
#   -   dereference symlinks first (stow links files in from the dotfiles repo)
#   .   then match only regular files
#   N   nullable - don't error if the directory is empty
#   :t  basename, since autoload wants names not paths
fpath=("$ZDOTDIR/functions" "$fpath")
autoload -Uz "$ZDOTDIR/functions"/*(-.N:t)

# Extra completions
# https://github.com/zsh-users/zsh-completions
# Must come before compinit
FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"

# Load completion system
# compinit runs a security check on every launch, this caches
# it for 24 hours
autoload -Uz compinit
zmodload -F zsh/stat b:zstat
zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -f $zcompdump ]] && (($(zstat +mtime "$zcompdump") > $(date +%s) - 86400)); then
    compinit -C -d "$zcompdump"
else
    compinit -d "$zcompdump"
fi
unset zcompdump

# Load zsh/complist for completion list keybindings. The actual menu UI is
# handled by fzf-tab (see fzf-tab.zsh), which sets `menu no` to disable zsh's
# built-in menu - so no `menu select` zstyle here.
zmodload zsh/complist

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

# zsh-defer: schedule expensive sourcing for after the first prompt renders.
# Not in homebrew, so clone-on-first-run into XDG_DATA_HOME.
# https://github.com/romkatv/zsh-defer
ZSH_DEFER_DIR="$XDG_DATA_HOME/zsh/zsh-defer"
if [[ ! -e $ZSH_DEFER_DIR/zsh-defer.plugin.zsh ]]; then
    git clone --depth=1 https://github.com/romkatv/zsh-defer.git "$ZSH_DEFER_DIR" &>/dev/null
fi
source "$ZSH_DEFER_DIR/zsh-defer.plugin.zsh"

# Aliases (cheap, load eagerly so they're available in any first command)
source "$ZDOTDIR/aliases.zsh"

# fzf-tab: replace the default completion menu with an fzf picker.
# Must be sourced AFTER compinit and BEFORE fast-syntax-highlighting.
# https://github.com/Aloxaf/fzf-tab
source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
source "$ZDOTDIR/fzf-tab.zsh"

# Externals like starship, atuin, mise etc.
source "$ZDOTDIR/externals.zsh"

# Autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
# Use catppuccin macchiato overlay0 so suggestions sit visibly behind the cursor
# shellcheck disable=SC2034 # It's a zsh config thing
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6e738d'
zsh-defer source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Abbreviations (fish-style auto-expanding) - deferred since the manager is
# heavy to load and abbreviations only matter once you start typing.
# https://github.com/olets/zsh-abbr
# shellcheck disable=SC2034 # It's a zsh config thing
ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/abbreviations"
zsh-defer source "$HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh"

# Syntax Highlighting (must be last on the line so it sees other widgets)
# https://github.com/zdharma-continuum/fast-syntax-highlighting
zsh-defer source "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Catppuccin Macchiato palette for fast-syntax-highlighting
# https://github.com/catppuccin/zsh-fsh
zsh-defer -c 'fast-theme "$ZDOTDIR/catppuccin-macchiato.ini" &>/dev/null'
