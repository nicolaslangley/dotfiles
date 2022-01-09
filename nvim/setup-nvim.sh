#!/usr/bin/env bash

# Copy autoload scripts and init.vim script
mkdir -p ~/.config/nvim
ln -sfhv $DOTFILES_DIR/nvim/autoload ~/.config/nvim/autoload 
ln -sfv $DOTFILES_DIR/nvim/init.vim ~/.config/nvim/init.vim 

# Install all Nvim Plugins
nvim +PlugInstall +qall


