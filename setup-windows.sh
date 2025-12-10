#!/usr/bin/env bash

# Windows-specific setup
echo "Setting up Windows configuration..."

# Add Windows-specific setup here
pip install --user git-revise

# Clone diff-so-fancy to parent directory if not already present
DIFF_SO_FANCY_DIR="$(dirname "$DOTFILES_DIR")/diff-so-fancy"
if [ ! -d "$DIFF_SO_FANCY_DIR" ]; then
  echo "Cloning diff-so-fancy to $DIFF_SO_FANCY_DIR..."
  git clone https://github.com/so-fancy/diff-so-fancy "$DIFF_SO_FANCY_DIR"
else
  echo "diff-so-fancy already exists at $DIFF_SO_FANCY_DIR"
fi

# Setup Alacritty config
ALACRITTY_CONFIG="$APPDATA/alacritty/alacritty.toml"
echo "Setting up Alacritty config at: $ALACRITTY_CONFIG"
mkdir -p "$(dirname "$ALACRITTY_CONFIG")"
cp $DOTFILES_DIR/alacritty/alacritty-windows.toml "$ALACRITTY_CONFIG"
echo "  Alacritty config copied"

# Setup Sublime Merge theme
# Symlink User settings directory to dotfiles
# Location: https://www.sublimemerge.com/docs/command_line (Windows config location)
SUBLIME_MERGE_USER="$APPDATA/Sublime Merge/Packages/User"
echo "Setting up Sublime Merge at: $SUBLIME_MERGE_USER"
if [ -e "$SUBLIME_MERGE_USER" ]; then
  echo "  Path exists, removing..."
  rm -rf "$SUBLIME_MERGE_USER"
else
  echo "  Path does not exist"
fi
ln -s $DOTFILES_DIR/themes/sublime/merge/User "$SUBLIME_MERGE_USER"
echo "  Symlink created"

# Setup Zed settings
# Copy settings.json to Zed config directory
ZED_SETTINGS="$APPDATA/Zed/settings.json"
echo "Setting up Zed settings at: $ZED_SETTINGS"
mkdir -p "$(dirname "$ZED_SETTINGS")"
echo "  Directory created"
cp $DOTFILES_DIR/zed/settings.json "$ZED_SETTINGS"
echo "  Settings file copied"
