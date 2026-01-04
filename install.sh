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

echo ""
echo "--------------------------------------------"
echo "Setting up dotfiles..."
echo "--------------------------------------------"

DOTFILES_DIR=~/Developer/dotfiles
export DOTFILES_DIR

# Zsh
echo ""
echo "Setting up Zsh..."
echo "  Symlinking zshrc..."
ln -sf $DOTFILES_DIR/zsh/zshrc ~/.zshrc
echo ""
echo "----"
echo "Note: Create ~/.zshrc.local for machine-specific aliases and local config."
echo "----"

# Install Oh-My-Zsh
echo ""
echo "Setting up oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://install.ohmyz.sh)" 
else
  echo "  Oh My Zsh is already installed. Skipping..."
fi

# Git (use platform-specific config or fall back to universal gitconfig)
echo ""
echo "Setting up Git..."
echo "  Symlinking gitconfig..."
ln -sf $DOTFILES_DIR/git/gitconfig ~/.gitconfig

# Git global gitignore
echo "  Symlinking gitignore_global..."
ln -sf $DOTFILES_DIR/git/gitignore_global ~/.gitignore_global

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
  echo "  Git local config already exists at ~/.gitconfig.local"
fi

# Tig (platform-specific config)
echo ""
echo "Setting up Tig..."
echo "  Symlinking tigrc..."
ln -sf $DOTFILES_DIR/tig/tigrc-$PLATFORM ~/.tigrc

# Setup scripts (platform-specific)
source $DOTFILES_DIR/setup-$PLATFORM.sh
