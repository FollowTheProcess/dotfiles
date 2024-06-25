#!/usr/bin/env fish

# Update, clean, and maintain everything
function maintenance -d "Automates various cleaning and updates."
    argparse --min-args 0 --max-args 0 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Keep everything updated and clean out accumulated rubbish."
        echo
        echo "Usage:"
        echo "  maintenance"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    # Homebrew
    set_color cyan
    echo
    echo "🍺 Updating and cleaning homebrew packages..."
    echo
    set_color normal
    brew update
    brew upgrade
    brew cleanup -s

    # restart shell incase anything that follows was updated
    source ~/.config/fish/config.fish

    # Python
    set_color cyan
    echo
    echo "🐍 Updating global python3 core dependencies..."
    echo
    set_color normal
    set PIP_REQUIRE_VIRTUALENV ""
    python3 -m pip install --upgrade pip setuptools wheel pipx

    # pipx
    set_color cyan
    echo
    echo "🛠  Updating pipx installed CLI programs..."
    echo
    set_color normal
    pipx upgrade-all

    # Rust
    set_color cyan
    echo
    echo "🦀 Updating rust..."
    echo
    set_color normal
    rustup self update
    rustup update

    # Go
    set_color cyan
    echo
    echo "🐰 Updating go tools..."
    echo
    set_color normal
    gup update

    # tldr
    set_color cyan
    echo
    echo "📓 Updating tldr..."
    echo
    set_color normal
    tldr --update

    # Admin
    set_color cyan
    echo
    echo "🗑  Emptying trash and cleaning Downloads..."
    echo
    set_color normal
    osascript ~/.config/fish/functions/helpers/empty_trash.applescript
    python ~/.config/fish/functions/helpers/empty_downloads.py

    set_color green
    echo
    echo "All done 🎉"
    echo
    set_color normal

end
