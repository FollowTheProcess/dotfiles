#!/usr/bin/env bash
#
# bootstrap.sh - one-command setup for a fresh macOS install.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/FollowTheProcess/dotfiles/main/bootstrap.sh | bash
#
# Runs six steps in order, each guarded so re-running is safe:
#   1. Install Homebrew
#   2. Install GNU stow
#   3. Clone this repo to ~/dotfiles
#   4. make stow
#   5. brew bundle install --global
#   6. setup.sh then macos.sh

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${GREEN}==> $1${NC}"
}

# 1. Homebrew
if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed, skipping"
else
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available to the rest of this script regardless of whether
# it was just installed or already present.
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. GNU stow
if command -v stow >/dev/null 2>&1; then
    log "stow already installed, skipping"
else
    log "Installing stow..."
    brew install stow
fi

# 3. Clone repo
if [ -d "$HOME/dotfiles/.git" ]; then
    log "$HOME/dotfiles already cloned, skipping"
else
    log "Cloning dotfiles to $HOME/dotfiles..."
    git clone https://github.com/FollowTheProcess/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles"

# 4. Stow
log "Running make stow..."
make stow

# 5. Brewfile
log "Installing brew bundle (this may take a while)..."
brew bundle install --global

# 6. Post-install + macOS defaults
log "Installing Sketchybar Lua API..."
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install)

log "Installing Rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

log "Creating ~/Development folder..."
mkdir -p ~/Development

log "Building bat theme cache..."
bat cache --build

log "Setting nushell as the default shell (requires sudo)..."
echo /opt/homebrew/bin/nu | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/nu

log "Configuring macOS defaults (requires sudo)..."
./macos.sh

log "🚀 Bootstrap complete. Restart for all macOS settings to take effect."
