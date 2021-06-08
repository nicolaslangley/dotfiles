#!/usr/bin/env bash

# Copy Ayu mirage theme to Xcode
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cp -f $DOTFILES_DIR/themes/xcode/Ayu\ Mirage.xccolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

# Copy custom sourcetrail theme if installed
SOURCETRAIL_COLORSCHEME_DIR=/Applications/Sourcetrail.app/Contents/Resources/data/color_schemes/
if [ -d "$SOURCETRAIL_COLORSCHEME_DIR" ]; then
  cp -f $DOTFILES_DIR/themes/sourcetrail/custom.xml $SOURCETRAIL_COLORSCHEME_DIR
fi


