#!/usr/bin/env bash

# Display README with manual installation steps
cat README.md
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi

# Detect platform - only MacOS / Windows
if [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  PLATFORM="windows"
fi

echo "Installing dotfiles for $PLATFORM platform..."

DOTFILES_DIR=~/Developer/dotfiles
export DOTFILES_DIR
# Create symlink for ~/.dotfiles
ln -sfhv $DOTFILES_DIR ~/.dotfiles

# Zsh
ln -sfv $DOTFILES_DIR/zsh/zshrc ~/.zshrc

# Git (use platform-specific config or fall back to universal gitconfig)
if [[ -f "$DOTFILES_DIR/git/gitconfig-$PLATFORM" ]]; then
  ln -sfv $DOTFILES_DIR/git/gitconfig-$PLATFORM ~/.gitconfig
else
  ln -sfv $DOTFILES_DIR/git/gitconfig ~/.gitconfig
fi

# Git global gitignore
ln -sfv $DOTFILES_DIR/git/gitignore_global ~/.gitignore_global

# Git local config (user-specific)
if [[ ! -f ~/.gitconfig.local ]]; then
  echo ""
  read -p "Enter your Git email: " GIT_EMAIL
  read -p "Enter your Git user name: " GIT_USER

  # Create .gitconfig.local with user settings
  cat > ~/.gitconfig.local << EOF
[user]
	email = $GIT_EMAIL
	name = $GIT_USER
EOF
else
  echo "Git local config already exists at ~/.gitconfig.local"
fi

# Include local config in main gitconfig
git config --global include.path '~/.gitconfig.local'

# Alacritty (platform-specific config)
mkdir -p ~/.config/alacritty
ln -sfv $DOTFILES_DIR/alacritty/alacritty-$PLATFORM.yml ~/.config/alacritty/alacritty.yml

# Tig (platform-specific config)
ln -sfv $DOTFILES_DIR/tig/tigrc-$PLATFORM ~/.tigrc

# Zed
mkdir -p ~/.config/zed
ln -sfv $DOTFILES_DIR/zed/settings.json ~/.config/zed/settings.json

# Setup scripts (platform-specific)
source $DOTFILES_DIR/setup-$PLATFORM.sh
