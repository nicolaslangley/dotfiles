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
if [ -e "$ALACRITTY_CONFIG" ]; then
  echo "  Path exists, removing..."
  rm -f "$ALACRITTY_CONFIG"
fi
ln -s $DOTFILES_DIR/alacritty/alacritty-windows.toml "$ALACRITTY_CONFIG"
echo "  Symlink created"

# Setup Sublime Merge
# Location: https://www.sublimemerge.com/docs/command_line (Windows config location)
SUBLIME_MERGE_USER="$APPDATA/Sublime Merge/Packages/User"
echo "Setting up Sublime Merge at: $SUBLIME_MERGE_USER"
mkdir -p "$SUBLIME_MERGE_USER"

# Copy color scheme and .sublime-settings files
echo "  Copying color scheme and settings files..."
cp $DOTFILES_DIR/themes/sublime/merge/User/ayu-mirage.sublime-color-scheme "$SUBLIME_MERGE_USER/"
cp $DOTFILES_DIR/themes/sublime/merge/User/*.sublime-settings "$SUBLIME_MERGE_USER/"
echo "  Files copied"

# Symlink preferences files
echo "  Symlinking preference files..."
for prefs_file in Preferences.sublime-settings Preferences-Windows.sublime-settings Preferences-macOS.sublime-settings; do
  PREFS_PATH="$SUBLIME_MERGE_USER/$prefs_file"
  if [ -e "$PREFS_PATH" ]; then
    rm -f "$PREFS_PATH"
  fi
  ln -s $DOTFILES_DIR/themes/sublime/merge/User/$prefs_file "$PREFS_PATH"
done

# Symlink keymap
echo "  Symlinking keymap..."
KEYMAP_PATH="$SUBLIME_MERGE_USER/Default.sublime-keymap"
if [ -e "$KEYMAP_PATH" ]; then
  rm -f "$KEYMAP_PATH"
fi
ln -s $DOTFILES_DIR/themes/sublime/merge/User/Default.sublime-keymap "$KEYMAP_PATH"
echo "  Sublime Merge setup complete"

# Setup Sublime Text
SUBLIME_TEXT_USER="$APPDATA/Sublime Text/Packages/User"
echo "Setting up Sublime Text at: $SUBLIME_TEXT_USER"
mkdir -p "$SUBLIME_TEXT_USER"

# Symlink settings
echo "  Symlinking Sublime Text settings..."
for file in "Preferences.sublime-settings" "Package Control.sublime-settings"; do
  TARGET="$SUBLIME_TEXT_USER/$file"
  if [ -e "$TARGET" ]; then rm -f "$TARGET"; fi
  ln -s "$DOTFILES_DIR/sublime/text/User/$file" "$TARGET"
done

# Symlink keymap (Windows version)
echo "  Symlinking Sublime Text keymap..."
TARGET_KEYMAP="$SUBLIME_TEXT_USER/Default (Windows).sublime-keymap"
if [ -e "$TARGET_KEYMAP" ]; then rm -f "$TARGET_KEYMAP"; fi
ln -s "$DOTFILES_DIR/sublime/text/User/Default (Windows).sublime-keymap" "$TARGET_KEYMAP"
echo "  Sublime Text setup complete"

# Setup Zed settings
ZED_SETTINGS="$APPDATA/Zed/settings.json"
echo "Setting up Zed settings at: $ZED_SETTINGS"
mkdir -p "$(dirname "$ZED_SETTINGS")"
if [ -e "$ZED_SETTINGS" ]; then
  echo "  Path exists, removing..."
  rm -f "$ZED_SETTINGS"
fi
ln -s $DOTFILES_DIR/zed/settings.json "$ZED_SETTINGS"
echo "  Symlink created"
