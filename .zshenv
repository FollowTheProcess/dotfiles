# A thin stub to point all zsh config to $XDG_CONFIG_HOME/zsh.
export ZDOTDIR="$HOME/.config/zsh"
[ -f "$ZDOTDIR/.zshenv" ] && . "$ZDOTDIR/.zshenv"
