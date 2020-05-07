
##############################
# Platform specific environment
##############################

if [ "$(uname -s)" = "Darwin" ]; then
  # Vulkan for MacOS
  export VULKAN_SDK=$HOME/Development/Tools/vulkansdk/macOS
  export VK_ICD_FILENAMES=$VULKAN_SDK/etc/vulkan/icd.d/MoltenVK_icd.json
  export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d
  export DYLD_LIBRARY_PATH=$VULKAN_SDK/lib:$DYLD_LIBRARY_PATH
  export VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump:VK_LAYER_KHRONOS_validation
fi

##############################
# Common environment
##############################

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export GIT_GUI='smerge'
export GIT_EDITOR='nvim'

# Python
export PYTHONSTARTUP=~/.pythonrc.py

