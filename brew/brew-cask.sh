# Update Homebrew Cask applications

brew cask update

core_apps=(
alfred
appcleaner
bettertouchtool
cyberduck
dropbox
flux
google-chrome
google-drive
iterm2
karabiner
notational-velocity
smcfancontrol
spotify
sqlitebrowser
the-unarchiver
unrarx
vlc
1password
)

dev_apps=(
dash
gitup
sourcetree
)

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
qlplugins=(
qlcolorcode
qlstephen
qlmarkdown
quicklook-json
qlprettypatch
quicklook-csv
betterzipql
webpquicklook
suspicious-package
)


if [ "$1" = "core" ]; then 
  brew cask install "${core_apps[@]}"
else
  if [ "$1" = "dev" ]; then
    brew cask install "${dev_apps[@]}"
  else
    if [ "$1" = "all" ]; then
      brew cask install "${core_apps[@]}"
      brew cask install "${dev_apps[@]}"
    else
      echo "Usage:"
      echo "core:     Install core apps"
      echo "dev:      Install development apps"
      echo "all:      Install all apps"
      exit 1
    fi
  fi
fi

brew cask install "${qlplugins[@]}"
qlmanage -r

