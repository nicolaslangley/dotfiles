
########################
# Platform specific aliases
########################

if [ "$(uname -s)" = "Darwin" ]; then
  # Clang aliases
  alias setup-coverage="source $DOTFILES_DIR/scripts/setup-coverage.sh"
  alias process-coverage="$DOTFILES_DIR/scripts/process-coverage.sh"
  alias export-coverage="$DOTFILES_DIR/scripts/export-coverage.sh"
  alias show-coverage="$DOTFILES_DIR/scripts/show-coverage.sh"
  alias llvm-cov="xcrun llvm-cov"
  alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
fi

########################
# Common aliases
########################

# Custom aliases
alias Dev="cd ~/Development"
alias mux="tmuxinator"

# Shortcuts
alias g="git"
alias nv="nvim"
alias vim="nvim"
alias rr="rm -rf"

# Remappings
alias cat="bat" # https://github.com/sharkdp/bat
alias grep="rg" # https://github.com/BurntSushi/ripgrep
alias ls="lsd" # https://github.com/Peltoche/lsd

# List declared aliases and functions
alias listaliases="alias | sed 's/=.*//'"
alias listfunctions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'" # show non _prefixed functions

# cd 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# Script aliases
alias git-status="$DOTFILES_DIR/scripts/git_status.sh"
