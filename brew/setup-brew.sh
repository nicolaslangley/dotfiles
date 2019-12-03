#!/usr/bin/env bash

# Check if brew is already installed
if [[ $(command -v brew) == "" ]]; then
  # Install brew if not found
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap homebrew/versions
fi

# Install core brew packages
$DOTFILES_DIR/brew/brew.sh core
