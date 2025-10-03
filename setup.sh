#!/usr/bin/env zsh

GREEN='\033[0;32m'
NC='\033[0m'

# Rust
echo -e "${GREEN}Installing Rustup...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Go
gup import --input ~/.config/gup/gup.conf

# Create dev projects folder
echo -e "${GREEN}Making coding projects folder...${NC}"
mkdir -p ~/Development

# Add nushell as a shell and make it the default
echo -e "${GREEN}Setting nushell as default shell (requires sudo)...${NC}"
echo /opt/homebrew/bin/nu | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/nu

# macOS Preferences
echo -e "${GREEN}Configuring macOS preferences...${NC}"
echo "FYI you will need to restart afterwards for many of these to take effect"
zsh macos.sh
