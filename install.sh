#!/usr/bin/env bash

DOTFILES_DIR=~/Development/dotfiles
export DOTFILES_DIR

ln -sfhv $DOTFILES_DIR ~/.dotfiles 

mkdir -p ~/.config/alacritty
ln -sfv $DOTFILES_DIR/alacritty/alacritty_osx.yml ~/.config/alacritty/alacritty.yml 

ln -sfv $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf 

ln -sfv $DOTFILES_DIR/tig/tigrc ~/.tigrc 

ln -sfv $DOTFILES_DIR/zsh/zshrc ~/.zshrc 

mkdir -p ~/.config/nvim
ln -sfhv $DOTFILES_DIR/nvim/autoload ~/.config/nvim/autoload 
ln -sfv $DOTFILES_DIR/nvim/init.vim ~/.config/nvim/init.vim 

nvim +PlugInstall +qall

source brew/setup-brew.sh

source sublime/setup-sublime.sh

