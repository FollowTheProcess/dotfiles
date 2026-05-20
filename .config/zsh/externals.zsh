# Launch GPG Agent (cheap, but needs to run before any signed commit)
gpgconf --launch gpg-agent

# Starship prompt - must load eagerly so the first prompt renders correctly
eval "$(starship init zsh)"

# Carapace - completion engine bridge. Loads eagerly because compinit-style
# state must exist before any completion attempt.
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Zoxide - smarter cd, hooks chpwd so needs to be active for any directory move
eval "$(zoxide init zsh)"

# fzf - keybindings (Ctrl-T, Alt-C) and completion. Loads eagerly so the
# keybinds work in the very first prompt.
source <(fzf --zsh)

# Atuin - replaces the up-arrow and Ctrl-R bindings. Defer until after the
# first prompt; if you hit Ctrl-R immediately on shell start, the default
# binding handles that single keystroke before atuin takes over.
# Quote the whole command so the `$(atuin init zsh)` subshell is also deferred.
zsh-defer -c 'eval "$(atuin init zsh)"'

# Mise - tool version manager. The slowest of the activators, so defer it.
# Anything that needs mise-managed tools right at shell start (rare) would
# need to wait for the deferred eval to land.
zsh-defer -c 'eval "$(mise activate zsh)"'
