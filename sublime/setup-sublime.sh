#!/usr/bin/env bash

if [ "$(uname -s)" = "Darwin" ]; then
  # Copy settings for Sublime Text
  cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/
  rm -r User
  ln -s ~/.dotfiles/sublime/text/User
  # Copy settings for Sublime Merge
  cd ~/Library/Application\ Support/Sublime\ Merge/Packages/
  rm -r User
  ln -s ~/.dotfiles/sublime/merge/User
else
  # Assume Linux platforms if not MacOS
  # Copy settings for Sublime Text
  cd ~/.config/sublime-text-3/Packages/
  rm -r User
  ln -s ~/.dotfiles/sublime/text/User
  # Copy settings for Sublime Merge
  cd ~/.config/sublime-merge/Packages/
  rm -r User
  ln -s ~/.dotfiles/sublime/merge/User
fi
