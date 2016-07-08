#!/usr/bin/env bash

# Install brew & brew cask
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew install brew-cask
brew tap homebrew/versions
brew tap caskroom/versions

# Install brew & brew cask packages
. "$DOTFILES_DIR/brew/brew.sh" "core"
. "$DOTFILES_DIR/brew/brew-cask.sh" "core"
