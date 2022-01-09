# Update Homebrew, formulae, and packages
brew update
brew upgrade

core=(
autoconf
automake
bat
cmake
diff-so-fancy
fzf
lsd
nvim
python
reattach-to-user-namespace
ripgrep
tig
git-revise
git-lfs
tmux
)

if [ "$1" = "core" ]; then 
  brew install "${core[@]}"
fi

# Install fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
