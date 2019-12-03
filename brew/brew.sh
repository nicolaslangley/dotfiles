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
the_silver_searcher
tig
tmux
)

if [ "$1" = "core" ]; then 
  brew install "${core[@]}"
fi

