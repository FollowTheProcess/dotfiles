#!/usr/bin/env fish

set -U fish_greeting ""


# Global constants
set -U projdir $HOME/Development

# Env variables
set -gx GITHUB_TOKEN REPLACE ME # TODO: Replace with your token
set -gx PIP_REQUIRE_VIRTUALENV true
set -gx PIPENV_VENV_IN_PROJECT 1
set -gx PIPENV_VERBOSITY -1
set -gx EDITOR code --wait
set -gx GOPATH $HOME/go
set -gx GOBIN $GOPATH/bin
set -gx CGO_ENABLED 0

# This is so fish doesn't break on M1 mac
fish_add_path /opt/homebrew/bin

# Python launcher
set -gx PY_PYTHON (head -n 1 (pyenv root)/version | cut -d "." -f 1,2)

# Pyenv
status is-interactive; and pyenv init --path | source
pyenv init - | source

# GPG stuff
set -gx GPG_TTY (tty)
gpgconf --launch gpg-agent &>/dev/null

# So go binaries are available on PATH
fish_add_path $GOBIN

# Newer curl
fish_add_path /opt/homebrew/opt/curl/bin

# Starship
starship init fish | source

# Created by `pipx` on 2021-06-11 09:35:24
fish_add_path "$HOME/.local/bin"

# Rust
fish_add_path "$HOME/.cargo/bin"

# zoxide
zoxide init fish | source

# Mcfly
mcfly init fish | source

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
