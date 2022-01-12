#!/usr/bin/env bash

# Update alacritty icon
iconutil -c icns $DOTFILES_DIR/alacritty/icon/alacritty.iconset -o /Applications/Alacritty.app/Contents/Resources/alacritty.icns
# Clear MacOS icon cache
sudo rm -rfv /Library/Caches/com.apple.iconservices.store; sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \; ; sleep 3;sudo touch /Applications/* ; killall Dock; killall Finder
