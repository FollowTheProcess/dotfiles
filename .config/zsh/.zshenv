# XDG Stuff
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editor
export EDITOR="zed --wait"
export VISUAL="zed --wait"

# Granted: https://docs.commonfate.io/granted/internals/shell-alias
export GRANTED_ALIAS_CONFIGURED="true"

# Use bat as the pager for man. MANROFFOPT="-c" fixes bold/underline
# rendering on macOS where mandoc otherwise strips the formatting.
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# GPG
export GPG_TTY=$TTY

# Python: never let pip install outside a virtualenv. Force UTF-8 mode.
export PIP_REQUIRE_VIRTUALENV=true
export PYTHONUTF8=1
export VIRTUALENV_PROMPT='.venv'

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GO111MODULE=on
export CGO_ENABLED=0
export GOEXPERIMENT=jsonv2

# Rust
export CARGO_HOME="$HOME/.cargo"

# Use difftastic for `kubectl diff` output
export KUBECTL_EXTERNAL_DIFF="difft --exit-code"

# Catppuccin Macchiato palette for ls, eza, fd, zsh completions, etc.
export LS_COLORS="$(<"$XDG_CONFIG_HOME/ls-colors/catppuccin-macchiato")"

# fzf: layout + catppuccin macchiato palette.
# https://github.com/catppuccin/fzf
export FZF_DEFAULT_OPTS="\
--height=40% --layout=reverse --border=rounded --info=inline \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5"

# Use fd for fzf's file/dir walks - faster, respects .gitignore.
export FZF_DEFAULT_COMMAND='fd --type=f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --follow --exclude .git'

# Previews: bat for files (with syntax highlight), eza tree for dirs.
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=auto {} | head -200'"

# Carapace
export CARAPACE_BRIDGES="zsh"
