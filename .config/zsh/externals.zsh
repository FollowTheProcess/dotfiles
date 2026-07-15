# Launch GPG Agent (cheap, but needs to run before any signed commit)
gpgconf --launch gpg-agent

# Starship prompt - must load eagerly so the first prompt renders correctly
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Zoxide - smarter cd, hooks chpwd so needs to be active for any directory move
eval "$(zoxide init zsh --cmd cd)"

# fzf - keybindings (Ctrl-T, Alt-C) and completion. Loads eagerly so the
# keybinds work in the very first prompt.
source <(fzf --zsh)

# Atuin - replaces the up-arrow and Ctrl-R bindings. Defer until after the
# first prompt; if you hit Ctrl-R immediately on shell start, the default
# binding handles that single keystroke before atuin takes over.
# Quote the whole command so the `$(atuin init zsh)` subshell is also deferred.
zsh-defer -c 'eval "$(atuin init zsh)"'
