#!/usr/bin/env bash

# macOS-specific setup
echo "Setting up macOS configuration..."

# Check if brew is already installed
if [[ $(command -v brew) == "" ]]; then
  # Install brew if not found
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade

brew install fzf
brew install tig
brew install python
brew install git-revise
brew install git-lfs
brew install diff-so-fancy

# Setup Sublime Merge themes
# Symlink User settings directory to dotfiles
# Location: https://www.sublimemerge.com/docs/command_line
rm -r ~/Library/Application\ Support/Sublime\ Merge/Packages/User
ln -sfhv ~/.dotfiles/themes/sublime/merge/User ~/Library/Application\ Support/Sublime\ Merge/Packages/User

# Create symlink for smerge CLI command
if [[ -L /usr/local/bin/smerge ]]; then
  echo "Sublime Merge CLI symlink already exists."
else
  echo "Setting up Sublime Merge CLI (requires sudo to write to /usr/local/bin)..."
  sudo ln -sfv /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge /usr/local/bin/smerge
fi

# Copy Ayu mirage theme to Xcode
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cp -f $DOTFILES_DIR/themes/xcode/Ayu\ Mirage.xccolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

# Alacritty (macOS-specific config)
mkdir -p ~/.config/alacritty
ln -sfv $DOTFILES_DIR/alacritty/alacritty-macos.toml ~/.config/alacritty/alacritty.toml

# Zed
mkdir -p ~/.config/zed
ln -sfv $DOTFILES_DIR/zed/settings.json ~/.config/zed/settings.json
