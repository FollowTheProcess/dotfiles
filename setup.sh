#!/usr/bin/env zsh

GREEN='\033[0;32m'
NC='\033[0m'

# Rust
echo -e "${GREEN}Installing Rustup...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Create dev projects folder
echo -e "${GREEN}Making coding projects folder...${NC}"
mkdir -p ~/Development

# Build the bat cache so any custom themes/syntaxes under ~/.config/bat are
# compiled into the binary cache and picked up immediately.
echo -e "${GREEN}Building bat cache...${NC}"
bat cache --build

# Add nushell as a shell and make it the default
echo -e "${GREEN}Setting nushell as default shell (requires sudo)...${NC}"
echo /opt/homebrew/bin/nu | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/nu

# macOS Preferences
echo -e "${GREEN}Configuring macOS preferences...${NC}"
echo "FYI you will need to restart afterwards for many of these to take effect"
zsh macos.sh
