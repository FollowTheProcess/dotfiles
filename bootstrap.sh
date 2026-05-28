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
#   4. make stow (+ link ~/.claude/skills -> ~/.config/ai/skills)
#   5. brew bundle install --global
#   6. Post-install tooling, then macos.sh

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

# Claude Code only auto-loads skills from ~/.claude/skills, but the skills
# themselves live in ~/.config/ai/skills (stowed above). Point one at the
# other so they load natively, no plugin machinery required.
#
# Replace anything that isn't already the correct symlink so
# re-running self-heals the links.
skills_target="$HOME/.config/ai/skills"
skills_link="$HOME/.claude/skills"
mkdir -p "$HOME/.claude"
if [ "$(readlink "$skills_link" 2>/dev/null || true)" = "$skills_target" ]; then
    log "~/.claude/skills already linked, skipping"
else
    log "Linking ~/.claude/skills -> ~/.config/ai/skills..."
    rm -rf "$skills_link"
    ln -s "$skills_target" "$skills_link"
fi

# 5. Brewfile
log "Installing brew bundle (this may take a while)..."
brew bundle install --global

# 6. Post-install + macOS defaults
if [ -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]; then
    log "Sketchybar Lua API already installed, skipping"
else
    log "Installing Sketchybar Lua API..."
    rm -rf /tmp/SbarLua
    git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
    make -C /tmp/SbarLua install
    rm -rf /tmp/SbarLua
fi

if [ -x "$HOME/.cargo/bin/rustup" ]; then
    log "Rustup already installed, skipping"
else
    log "Installing Rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

log "Ensuring ~/Development folder exists..."
mkdir -p ~/Development

log "Building bat theme cache..."
bat cache --build

# $SHELL reflects the parent process, not the login shell, so query the
# directory service for the real value before deciding to run chsh.
current_shell=$(dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}')
if grep -qxF /opt/homebrew/bin/nu /etc/shells && [ "$current_shell" = "/opt/homebrew/bin/nu" ]; then
    log "nushell already the default shell, skipping"
else
    log "Setting nushell as the default shell (requires sudo)..."
    grep -qxF /opt/homebrew/bin/nu /etc/shells || echo /opt/homebrew/bin/nu | sudo tee -a /etc/shells >/dev/null
    [ "$current_shell" = "/opt/homebrew/bin/nu" ] || chsh -s /opt/homebrew/bin/nu
fi

log "Configuring macOS defaults (requires sudo)..."
./macos.sh

log "🚀 Bootstrap complete. Restart for all macOS settings to take effect."
