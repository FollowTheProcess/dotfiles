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

# Can't get these on brew and they took me ages to find
echo -e "${GREEN}Copying fonts...${NC}"
cp -r SF-Mono-Original ~/Library/Fonts/
cp -r SF-Mono-Ligaturised ~/Library/Fonts/
cp -r SF-Mono-Nerd-Font ~/Library/Fonts/
cp Inconsolata-g.ttf ~/Library/Fonts/
cp RobotoMono.ttf ~/Library/Fonts/

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
cp .cookiecutterrc $HOME/
cp .condarc $HOME/
cp .gitconfig $HOME/
cp .gitignore $HOME/
cp .pypirc $HOME/
cp .pytoil.toml $HOME/
cp -r hatch $HOME/Library/Application\ Support/hatch
cp -r ruff $HOME/.config/
cp -r pypoetry $HOME/Library/Preferences/
cp -r .cargo $HOME/

# Create dev projects folder
echo -e "${GREEN}Making coding projects folder...${NC}"
mkdir -p ~/Development

# macOS Preferences
echo -e "${GREEN}Configuring macOS preferences...${NC}"
echo "FYI you will need to restart for these to take effect"
echo "But after that, you're done!"
sudo sh macos.sh
