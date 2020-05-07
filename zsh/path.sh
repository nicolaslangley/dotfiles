# Function for adding to path
function prepend-path() { [ -d $1 ] && PATH="$1:$PATH" }

########################
# Platform specific path setup
########################

if [ "$(uname -s)" = "Darwin" ]; then
  prepend-path "/usr/local/opt/llvm/bin"
  prepend-path "$HOME/Library/Python/2.7/lib/python/site-packages"
  prepend-path "/usr/local/share/git-core/contrib/diff-highlight/diff-highlight"
  # Add Python3 to path'
  prepend-path "$HOME/Library/Python/3.7/bin"
  # Add Vulkan SDK to path
  prepend-path "$VULKAN_SDK/bin"
  # GLSL tools
  prepend-path "$HOME/Development/Tools/spirv_cross_rtc/bin"
fi

########################
# Common path setup
########################

prepend-path "/bin"
prepend-path "/usr/bin"
prepend-path "/usr/local/bin"
prepend-path "/sbin"
prepend-path "/usr/sbin"
prepend-path "/usr/local/sbin"
prepend-path "$HOME/bin"
prepend-path "$DOTFILES_DIR/bin"
# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755
PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
export PATH
