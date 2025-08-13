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

# Set up system-wide $PATH so that non-terminal applications can see $PATH as I intend it
# these are named {priority}-{name} and are loaded in priority order
echo -e "${GREEN}Setting global PATH (requires sudo)...${NC}"
echo /opt/homebrew/bin | sudo tee -a /etc/paths.d/20-homebrew
echo /opt/homebrew/opt/ruby/bin | sudo tee -a /etc/paths.d/20-homebrew
echo $HOME/.cargo/bin | sudo tee -a /etc/paths.d/30-cargo
echo $HOME/.local/bin | sudo tee -a /etc/paths.d/40-local
echo $HOME/go/bin | sudo tee -a /etc/paths.d/50-go

# macOS Preferences
echo -e "${GREEN}Configuring macOS preferences...${NC}"
echo "FYI you will need to restart afterwards for many of these to take effect"
zsh macos.sh
