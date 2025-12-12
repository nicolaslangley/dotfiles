# Windows (Git Bash) specific path setup
function prepend-path() { [ -d $1 ] && PATH="$1:$PATH" }

prepend-path "/bin"
prepend-path "/usr/bin"
prepend-path "/usr/local/bin"
prepend-path "$HOME/bin"
prepend-path "$DOTFILES_DIR/bin"
prepend-path "$(dirname "$DOTFILES_DIR")/diff-so-fancy"
prepend-path "/c/Strawberry/perl/bin"
prepend-path "$HOME/Developer/raddbg"

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755
PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
export PATH
