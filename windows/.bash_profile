# Set Agnoster theme for bash
export THEME=/c/Development/dotfiles/bash/themes/agnoster-bash/agnoster.bash
if [[ -f $THEME  ]]; then
  export DEFAULT_USER=`whoami`
  source $THEME
fi

# Set directory colors
eval `dircolors ~/.dir_colors`

# Alias for RTC
alias RTC-code='cd /c/Development/Quartz/runtimecore'
alias RTC-scripts='cd /c/Development/Quartz/runtimecore/runtimecore_scripts/scripts'
alias RTC-tools='cd /c/Development/Quartz/runtimecore/runtimecore_scripts/tools'
alias RTC-output='cd /c/Development/Quartz/output/win_x64_debug/bin'
alias editrtc='cd /c/Development/Quartz/runtimecore && vim'
alias apitrace='/c/Development/Graphics_tools/apitrace-msvc/x64/bin/apitrace.exe'
alias qapitrace='/c/Development/Graphics_tools/apitrace-msvc/x64/bin/qapitrace.exe'
alias git-clean-rtc='/c/Development/dotfiles/scripts/git_clean_branches_rtc.sh'

export QT_HOME=/c/Qt/Qt5.9.2/5.9.2
