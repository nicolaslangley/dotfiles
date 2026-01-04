#!/usr/bin/env bash

# Windows-specific setup
echo ""
echo "Setting up Windows configuration..."

# Add Windows-specific setup here
echo ""
echo "Setting up git-revise..."
pip install --user git-revise

# Clone diff-so-fancy to parent directory if not already present
echo ""
echo "Setting up diff-so-fancy..."
DIFF_SO_FANCY_DIR="$(dirname "$DOTFILES_DIR")/diff-so-fancy"
if [ ! -d "$DIFF_SO_FANCY_DIR" ]; then
  echo "Cloning diff-so-fancy to $DIFF_SO_FANCY_DIR..."
  git clone https://github.com/so-fancy/diff-so-fancy "$DIFF_SO_FANCY_DIR"
else
  echo "diff-so-fancy already exists at $DIFF_SO_FANCY_DIR"
fi

# Setup Alacritty config
echo ""
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
echo ""
SUBLIME_MERGE_PACKAGES="$APPDATA/Sublime Merge/Packages"
echo "Setting up Sublime Merge at: $SUBLIME_MERGE_PACKAGES"
mkdir -p "$SUBLIME_MERGE_PACKAGES/User"

# Copy other settings files, excluding platform-specific preferences
find "$DOTFILES_DIR/sublime/merge/User" -name "*.sublime-settings" \
  ! -name "Preferences-macOS.sublime-settings" \
  ! -name "Preferences-Windows.sublime-settings" \
  -exec cp {} "$SUBLIME_MERGE_PACKAGES/User/" \;
echo "  Files copied"

# Symlink Windows specific preferences as Preferences.sublime-settings
echo "  Symlinking preference file..."
PREFS_TARGET="$SUBLIME_MERGE_PACKAGES/User/Preferences.sublime-settings"
if [ -e "$PREFS_TARGET" ]; then
  rm -f "$PREFS_TARGET"
fi
ln -s "$DOTFILES_DIR/sublime/merge/User/Preferences-Windows.sublime-settings" "$PREFS_TARGET"

# Symlink keymap
echo "  Symlinking keymap..."
KEYMAP_PATH="$SUBLIME_MERGE_PACKAGES/User/Default.sublime-keymap"
if [ -e "$KEYMAP_PATH" ]; then
  rm -f "$KEYMAP_PATH"
fi
ln -s $DOTFILES_DIR/sublime/merge/User/Default.sublime-keymap "$KEYMAP_PATH"

# Copy BetterFindBuffer
echo "  Copying Ayu Mirage Theme..."
rm -rf "$SUBLIME_MERGE_PACKAGES/ayu-mirage-theme"
cp -r "$DOTFILES_DIR/sublime/merge/ayu-mirage-theme" "$SUBLIME_MERGE_PACKAGES/ayu-mirage-theme"

echo "  Sublime Merge setup complete"

# Setup Sublime Text
echo ""
SUBLIME_TEXT_PACKAGES="$APPDATA/Sublime Text/Packages"
echo "Setting up Sublime Text at: $SUBLIME_TEXT_PACKAGES"
mkdir -p "$SUBLIME_TEXT_PACKAGES/User"

# Symlink settings
echo "  Symlinking Sublime Text settings..."
for file in "Preferences.sublime-settings" "Package Control.sublime-settings"; do
  TARGET="$SUBLIME_TEXT_PACKAGES/User/$file"
  if [ -e "$TARGET" ]; then rm -f "$TARGET"; fi
  ln -s "$DOTFILES_DIR/sublime/text/User/$file" "$TARGET"
done

# Symlink keymap (Windows version)
echo "  Symlinking Sublime Text keymap..."
TARGET_KEYMAP="$SUBLIME_TEXT_PACKAGES/User/Default (Windows).sublime-keymap"
if [ -e "$TARGET_KEYMAP" ]; then rm -f "$TARGET_KEYMAP"; fi
ln -s "$DOTFILES_DIR/sublime/text/User/Default (Windows).sublime-keymap" "$TARGET_KEYMAP"
echo "  Sublime Text setup complete"

# Copy BetterFindBuffer
echo "  Copying BetterFindBuffer..."
rm -rf "$SUBLIME_TEXT_PACKAGES/BetterFindBuffer"
cp -r "$DOTFILES_DIR/sublime/text/BetterFindBuffer" "$SUBLIME_TEXT_PACKAGES/BetterFindBuffer"
