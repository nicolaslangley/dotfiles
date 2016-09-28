#!/bin/zsh

##########
# Functions
##########

# File search
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Create and enter directory
function mk() { mkdir -p "$@" && cd "$_"; }

# Add to path
function prepend-path() { [ -d $1 ] && PATH="$1:$PATH" }

# Check for executable
is-executable() {
    local BIN=$(command -v "$1" 2>/dev/null)
    if [[ ! $BIN == "" && -x $BIN ]]; then true; else false; fi
}

##########
# Environment
##########

# Path
is-executable getconf && PATH=$(command -v getconf PATH)
prepend-path "/bin"
prepend-path "/usr/bin"
prepend-path "/usr/local/bin"
is-executable brew && prepend-path "$(brew --prefix coreutils)/libexec/gnubin"
prepend-path "$DOTFILES_DIR/bin"
prepend-path "$HOME/bin"
prepend-path "/sbin"
prepend-path "/usr/sbin"
prepend-path "/usr/local/sbin"
prepend-path "$HOME/.tmuxifier/bin"
# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755
PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
export PATH

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi
export EDITOR_NOWAIT='nvim'
export GIT_GUI='sourcetree'
export GIT_EDITOR='nvim'

# Java
export JAVA_HOME=$(/usr/libexec/java_home)
# Matlab setup
export MATLAB_JAVA="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"
# Python
export PYTHONSTARTUP=~/.pythonrc.py

##########
# Aliases
##########

# Zsh
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

#P4 Merge
alias p4merge="/Applications/p4merge.app/Contents/MacOS/p4merge"

# Custom aliases
alias School="cd ~/Dropbox/UCLA/\"Fall 2015\"/"
alias Dev="cd ~/Development"
alias Matlab="/Applications/MATLAB_R2014a.app/Contents/MacOS/StartMATLAB &"
alias matlabcli="/Applications/MATLAB_R2014a.app/bin/matlab -nodesktop -nosplash"

# API trace
alias apitrace="~/Development/apitrace/apitrace"
alias qapitrace="~/Development/apitrace/qapitrace"

# Shortcuts
alias g="git"
alias nv="nvim"
alias vim="nvim"
alias rr="rm -rf"

# List declared aliases and functions
alias listaliases="alias | sed 's/=.*//'"
alias listfunctions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'" # show non _prefixed functions

# cd 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

##########
# Scripts
##########
alias git-status="~/.dotfiles/scripts/git_status.sh"

