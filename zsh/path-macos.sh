# macOS specific path setup
function prepend-path() { [ -d $1 ] && PATH="$1:$PATH" }

prepend-path "/bin"
prepend-path "/usr/bin"
prepend-path "/usr/local/bin"
prepend-path "/sbin"
prepend-path "/usr/sbin"
prepend-path "/usr/local/sbin"
prepend-path "$HOME/bin"
prepend-path "$DOTFILES_DIR/bin"
prepend-path "$HOME/Library/Python/3.8/bin"

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755
PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
export PATH
