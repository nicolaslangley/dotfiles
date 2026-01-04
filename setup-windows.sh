#!/usr/bin/env bash

# Windows-specific setup
echo ""
echo "--------------------------------------------"
echo "Setting up Windows-specific configuration..."
echo "--------------------------------------------"

# Add Windows-specific setup here
echo ""
echo "Setting up git-revise..."
echo "  Install git-revise..."
pip install --user git-revise

# Clone diff-so-fancy to parent directory if not already present
echo ""
echo "Setting up diff-so-fancy..."
DIFF_SO_FANCY_DIR="$(dirname "$DOTFILES_DIR")/diff-so-fancy"
if [ ! -d "$DIFF_SO_FANCY_DIR" ]; then
  echo "  Cloning diff-so-fancy to $DIFF_SO_FANCY_DIR..."
  git clone https://github.com/so-fancy/diff-so-fancy "$DIFF_SO_FANCY_DIR"
else
  echo "  diff-so-fancy already exists at $DIFF_SO_FANCY_DIR. Skipping..."
fi

# Setup Alacritty config
echo ""
echo "Setting up Alacritty..."
ALACRITTY_CONFIG="$APPDATA/alacritty/alacritty.toml"
mkdir -p "$(dirname "$ALACRITTY_CONFIG")"
if [ -e "$ALACRITTY_CONFIG" ]; then
  rm -f "$ALACRITTY_CONFIG"
fi
echo "  Symlinking configuration..."
ln -s $DOTFILES_DIR/alacritty/alacritty-windows.toml "$ALACRITTY_CONFIG"

# Setup Sublime Merge
# Location: https://www.sublimemerge.com/docs/command_line (Windows config location)
echo ""
echo "Setting up Sublime Merge..."
SUBLIME_MERGE_PACKAGE_DIR="$APPDATA/Sublime Merge/Packages"
SUBLIME_MERGE_USER_DIR="$SUBLIME_MERGE_PACKAGE_DIR/User"
rm -rf "$SUBLIME_MERGE_USER_DIR"
mkdir -p "$SUBLIME_MERGE_USER_DIR"

# Copy other settings files, excluding platform-specific preferences
echo "  Copying settings..."
find "$DOTFILES_DIR/sublime/merge/User" -name "*.sublime-settings" \
  ! -name "Preferences-macOS.sublime-settings" \
  ! -name "Preferences-Windows.sublime-settings" \
  -exec cp {} "$SUBLIME_MERGE_USER_DIR/" \;
# Copy the platform specific settings
cp "$DOTFILES_DIR/sublime/merge/User/Preferences-Windows.sublime-settings" "$SUBLIME_MERGE_USER_DIR/Preferences.sublime-settings"
# Copy the keymap
cp "$DOTFILES_DIR/sublime/merge/User/Default.sublime-keymap" "$SUBLIME_MERGE_USER_DIR/Default.sublime-keymap"

# Copy Ayu Mirage Theme
echo "  Copying Ayu Mirage Theme..."
rm -rf "$SUBLIME_MERGE_PACKAGE_DIR/ayu-mirage-theme"
cp -r "$DOTFILES_DIR/sublime/merge/ayu-mirage-theme" "$SUBLIME_MERGE_PACKAGE_DIR/ayu-mirage-theme"

# Setup Sublime Text
echo ""
echo "Setting up Sublime Text..."
SUBLIME_TEXT_PACKAGE_DIR="$APPDATA/Sublime Text/Packages"
SUBLIME_TEXT_USER_DIR="$SUBLIME_TEXT_PACKAGE_DIR/User"

# Symlink settings
echo "  Copying settings..."
rm -rf "$SUBLIME_TEXT_USER_DIR"
cp -r "$DOTFILES_DIR/sublime/text/User" "$SUBLIME_TEXT_USER_DIR"

# Copy BetterFindBuffer
echo "  Copying BetterFindBuffer package..."
rm -rf "$SUBLIME_TEXT_PACKAGE_DIR/BetterFindBuffer"
cp -r "$DOTFILES_DIR/sublime/text/BetterFindBuffer" "$SUBLIME_TEXT_PACKAGE_DIR/BetterFindBuffer"

# Copy OpenInRadDebugger
echo "  Copying OpenInRadDebugger package..."
rm -rf "$SUBLIME_TEXT_PACKAGE_DIR/OpenInRadDebugger"
cp -r "$DOTFILES_DIR/sublime/text/OpenInRadDebugger" "$SUBLIME_TEXT_PACKAGE_DIR/OpenInRadDebugger"
