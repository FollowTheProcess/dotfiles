# Add things to $PATH. nix first so nix tools win over Homebrew; typeset -U
# dedupes the nix paths /etc/zprofile already injected.
typeset -U path PATH # keep entries unique
path=(
    /run/current-system/sw/bin        # nix-darwin systemPackages
    "$HOME/.nix-profile/bin"          # home-manager / nix user profile (once added)
    /nix/var/nix/profiles/default/bin # nix itself

    "$HOME/go/bin"             # GOBIN
    "$HOME/.bun/bin"           # bun
    "$HOME/.local/bin"         # uv and a bunch of other tools
    "$HOME/.cargo/bin"         # cargo install

    /opt/homebrew/bin          # Homebrew, after nix so nix wins
    /opt/homebrew/sbin
    /opt/homebrew/opt/curl/bin # use non-system curl
    /opt/homebrew/opt/ruby/bin # use non-system ruby

    $path
)
export PATH
