#!/usr/bin/env bash

# macOS-specific setup
echo ""
echo "--------------------------------------------"
echo "Setting up macOS-specific configuration..."
echo "--------------------------------------------"

# Check if brew is already installed
if [[ $(command -v brew) == "" ]]; then
  # Install brew if not found
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup Brew using Brewfile
echo ""
echo "Setting up Homebrew..."
BREWFILE_PATH="$DOTFILES_DIR/brew/Brewfile"
if [ -f "$BREWFILE_PATH" ]; then
    echo "  Installing dependencies from $BREWFILE_PATH..."
    brew bundle check --file="$BREWFILE_PATH" || brew bundle install --file="$BREWFILE_PATH"
else
    echo "  Error: Brewfile not found at $BREWFILE_PATH"
fi

echo ""
echo "Setting up Sublime Merge..."
SUBLIME_MERGE_PACKAGE_DIR=~/Library/Application\ Support/Sublime\ Merge/Packages
SUBLIME_MERGE_USER_DIR=$SUBLIME_MERGE_PACKAGE_DIR/User

echo "  Symlinking settings..."
rm -rf "$SUBLIME_MERGE_USER_DIR"
mkdir -p "$SUBLIME_MERGE_USER_DIR"
# Symlink all files from sublime/merge/User/ except the platform specific ones
for file in "$DOTFILES_DIR/sublime/merge/User/"*; do
  filename=$(basename "$file")
  if [[ "$filename" != "Preferences-macOS.sublime-settings" && "$filename" != "Preferences-Windows.sublime-settings" ]]; then
    ln -sf "$file" "$SUBLIME_MERGE_USER_DIR/$filename"
  fi
done
# Symlink macOS specific preferences as Preferences.sublime-settings
ln -sf "$DOTFILES_DIR/sublime/merge/User/Preferences-macOS.sublime-settings" "$SUBLIME_MERGE_USER_DIR/Preferences.sublime-settings"

echo "  Copying Ayu Mirage Theme..."
cp -r "$DOTFILES_DIR/sublime/merge/ayu-mirage-theme" "$SUBLIME_MERGE_PACKAGE_DIR/ayu-mirage-theme"

# Create symlink for smerge CLI command
if [[ -L /usr/local/bin/smerge ]]; then
  echo "  Sublime Merge CLI symlink already exists. Skipping..."
else
  echo "  Setting up Sublime Merge CLI..."
  sudo ln -sf /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge /usr/local/bin/smerge
fi

# Setup Sublime Text configuration
echo ""
echo "Setting up Sublime Text..."
SUBLIME_TEXT_PACKAGE_DIR=~/Library/Application\ Support/Sublime\ Text/Packages
SUBLIME_TEXT_USER_DIR="$SUBLIME_TEXT_PACKAGE_DIR/User"

echo "  Symlinking settings..."
rm -rf "$SUBLIME_TEXT_USER_DIR"
ln -sfh $DOTFILES_DIR/sublime/text/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
echo "  Copying BetterFindBuffer package..."
cp -r $DOTFILES_DIR/sublime/text/BetterFindBuffer ~/Library/Application\ Support/Sublime\ Text/Packages/BetterFindBuffer
echo "  Copying OpenInXcode package..."
cp -r $DOTFILES_DIR/sublime/text/OpenInXcode ~/Library/Application\ Support/Sublime\ Text/Packages/OpenInXcode

# Copy Ayu mirage theme to Xcode
echo ""
echo "Setting up Xcode..."
echo "  Copying Ayu Mirage Theme..."
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cp -f $DOTFILES_DIR/themes/xcode/Ayu\ Mirage.xccolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

# Alacritty (macOS-specific config)
echo ""
echo "Setting up Alacritty..."
mkdir -p ~/.config/alacritty
echo "  Symlinking configuration..."
ln -sf $DOTFILES_DIR/alacritty/alacritty-macos.toml ~/.config/alacritty/alacritty.toml
