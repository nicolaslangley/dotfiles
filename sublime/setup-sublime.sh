#!/usr/bin/env bash

if [ "$(uname -s)" = "Darwin" ]; then
  # Copy settings for Sublime Text
  rm -r ~/Library/Application\ Support/Sublime\ Text/Packages/User
  ln -sfhv ~/.dotfiles/sublime/text/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
  # Copy settings for Sublime Merge
  rm -r ~/Library/Application\ Support/Sublime\ Merge/Packages/User
  ln -sfhv ~/.dotfiles/sublime/merge/User ~/Library/Application\ Support/Sublime\ Merge/Packages/User
  ln -sfv /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge /usr/local/bin/smerge
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
