#!/usr/bin/env bash

# Windows-specific setup
echo "Setting up Windows configuration..."

# Add Windows-specific setup here
pip install --user git-revise

# Install diff-so-fancy via npm
npm install -g diff-so-fancy

# Setup Sublime Merge theme
# Symlink User settings directory to dotfiles
# Location: https://www.sublimemerge.com/docs/command_line (Windows config location)
SUBLIME_MERGE_USER="$APPDATA/Sublime Merge/Packages/User"
rm -rf "$SUBLIME_MERGE_USER"
ln -s ~/.dotfiles/themes/sublime/merge/User "$SUBLIME_MERGE_USER"
