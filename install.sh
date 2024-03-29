#!/usr/bin/env bash

DOTFILES_DIR=~/Developer/dotfiles
export DOTFILES_DIR

# Create symlink for ~/.dotfiles
ln -sfhv $DOTFILES_DIR ~/.dotfiles 

# Create configuration files symlinks

# Git
ln -sfv $DOTFILES_DIR/git/gitignore_global ~/.gitignore_global
ln -sfv $DOTFILES_DIR/git/gitconfig ~/.gitconfig 

# Alacritty
mkdir -p ~/.config/alacritty
ln -sfv $DOTFILES_DIR/alacritty/alacritty_osx.yml ~/.config/alacritty/alacritty.yml 

# Tmux
ln -sfv $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf 

# Tig
ln -sfv $DOTFILES_DIR/tig/tigrc ~/.tigrc 

# Zsh
ln -sfv $DOTFILES_DIR/zsh/zshrc ~/.zshrc 

# Setup Brew and install core libraries
source brew/setup-brew.sh

# Copy Sublime Text and Sublime Merge configurations
source sublime/setup-sublime.sh

# Copy themes
source themes/setup-themes.sh
