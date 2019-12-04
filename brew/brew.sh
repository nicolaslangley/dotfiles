# Update Homebrew, formulae, and packages
brew update
brew upgrade

core=(
antigen
cmake
ctags
git
neovim
reattach-to-user-namespace
ripgrep
tig
tmux
)

if [ "$1" = "core" ]; then 
  brew install "${core[@]}"
fi

