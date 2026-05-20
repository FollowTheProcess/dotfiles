# Add things to $PATH
typeset -U path PATH # keep entries unique
path=(
    "$HOME/go/bin"             # GOBIN
    "$HOME/.bun/bin"           # bun
    "$HOME/.local/bin"         # uv and a bunch of other tools
    "$HOME/.cargo/bin"         # cargo install
    /opt/homebrew/opt/curl/bin # use non-system curl
    /opt/homebrew/opt/ruby/bin # use non-system ruby
    "$path"
)
export PATH
