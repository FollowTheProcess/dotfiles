#!/usr/bin/env zsh

GREEN='\033[0;32m'
NC='\033[0m'

# Install Homebrew
echo -e "${GREEN}Installing Homebrew...${NC}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew upgrade
brew cleanup

# Install from the Brewfile
brew bundle --file Brewfile --no-lock

# Go
gup import --input ./gup.conf

# Rust
echo -e "${GREEN}Installing Rustup...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Dev stuff
echo -e "${GREEN}Copying config files...${NC}"
# Silence login in shells
touch ~/.hushlogin
touch ~/.hushprompt

# Copy all the things!
cp -r .config $HOME/
cp .gitconfig $HOME/
cp .gitignore $HOME/
cp -r hatch $HOME/Library/Application\ Support/hatch
cp -r pypoetry $HOME/Library/Application\ Support/pypoetry
cp -r .cargo $HOME/
cp -r nushell $HOME/Library/Application\ Support
cp -r copier $HOME/Library/Application\ Support

# Create dev projects folder
echo -e "${GREEN}Making coding projects folder...${NC}"
mkdir -p ~/Development

# Themes
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

# macOS Preferences
echo -e "${GREEN}Configuring macOS preferences...${NC}"
echo "FYI you will need to restart for these to take effect"
echo "But after that, you're done!"
sh macos.sh
