
########################
# RTC platform specific
########################

if [ "$(uname -s)" = "Darwin" ]; then
  # QT environment variables
  export QT_HOME=~/Development/Qt5.12.0/5.12.0
  export QT_PLUGIN_PATH=~/Development/Qt5.12.0/5.12.0/clang_64/plugins

  # RTC aliases
  alias RTC-output="cd ~/Development/Quartz/output/macos_x64_debug/bin"

  # Qt aliases
  alias qmake="~/Development/Qt5.12.0/5.12.0/clang_64/bin/qmake"
  alias qmake-mac="~/Development/Qt5.12.0/5.12.0/clang_64/bin/qmake"
  alias qmake-mac-qml-3d-app="~/Development/Qt5.12.0/5.12.0/clang_64/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml/runtimecore_test_qml.pro -r CONFIG+=debug"
  alias qmake-ios="~/Development/Qt5.12.0/5.12.0/ios/bin/qmake"
  alias qmake-qml-ios-3d-app="~/Development/Qt5.12.0/5.12.0/ios/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml/runtimecore_test_qml.pro -r CONFIG+=iphoneos CONFIG+=qml_debug"
  alias qmake-android="~/Development/Qt5.12.0/5.12.0/android_armv7/bin/qmake"
  alias qmake-qml-android-3d-app="~/Development/Qt5.12.0/5.12.0/android_armv7/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml/runtimecore_test_qml.pro -r -spec android-g++ CONFIG+=debug CONFIG+=qml_debug"
  alias androiddeployqt="~/Development/Qt5.12.0/5.12.0/android_armv7/bin/androiddeployqt"
  output_dir=android-qml3d-build
  alias android-qml-deploy="make install INSTALL_ROOT=\"$output_dir\" && ~/Development/Qt5.12.0/5.12.0/android_armv7/bin/androiddeployqt --output ./$output_dir/ --deployment bundled --android-platform android-26 --jdk /Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home --gradle"
  PATH="/Users/nico8506/Development/Qt5.12.0/5.12.0/clang_64/bin/:$PATH"

  # MacOS Android NDK and Toolchains
  alias adb="~/Development/Android/sdk/platform-tools/adb" 
  export ANDROID_SDK_ROOT=/Users/nico8506/Development/Android/sdk
  export ANDROID_NDK_ROOT=/Users/nico8506/Development/Android/android-ndk-r15b
  export ANDROID_TOOLCHAIN_ROOT=/Users/nico8506/Development/Android/toolchains
  export ANDROID_ARMV7=${ANDROID_TOOLCHAIN_ROOT}/android-16_arm_gnustl/bin
  export ANDROID_X86=${ANDROID_TOOLCHAIN_ROOT}/android-16_x86_gnustl/bin
  export ANDROIDGLES3_ARMV8=${ANDROID_TOOLCHAIN_ROOT}/android-21_21_arm64_gnustl/bin
  PATH="${ANDROIDGLES3_ARMV8}:$PATH"
  PATH="${ANDROIDGLES3_X86}:$PATH"
  PATH="${ANDROIDGLES3_X64}:$PATH"
else # Assume Linux platforms if not MacOS
  # Export QT (for linux)
  export QT_HOME=/opt/qt/Qt5.12.0/5.12.0
  # These aliases are for Linux systems
  alias RTC-output="cd ~/Development/Quartz/output/linux_x64_debug/bin"
  alias qmake-linux="/usr/local/qt/5.9.2/clang_64/bin/qmake"
  alias qmake-linux-qml-3d-app="/usr/local/qt/5.9.2/clang_64/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml/runtimecore_test_qml.pro -r CONFIG+=debug"
  alias nvidia-graphics-debugger="~/Development/Graphics_tools/Linux-Graphics-Debugger-2.3/nvidia-gfx-debugger&"
  alias nvidia-set-preload="export LD_PRELOAD="~/.tgd/libs/libNvidia_gfx_debugger.so""
  alias renderdoc="~/Development/Graphics_tools/renderdoc_1.0/bin/qrenderdoc"
fi

########################
# RTC aliases
########################

# Directory aliases
alias RTC="cd ~/Development/Quartz"
alias RTC-code="cd ~/Development/Quartz/runtimecore"
alias RTC-mr3d-dir="cd ~/Development/Quartz/runtimecore/map_renderer_3d"
alias RTC-mr3d-pipeline="cd ~/Development/Quartz/runtimecore/map_renderer_3d/src/graphics_pipeline3d"
alias RTC-mr3d-low-level="cd ~/Development/Quartz/runtimecore/map_renderer_3d/src/graphics_pipeline3d/low_level_renderer"
alias RTC-scripts="cd ~/Development/Quartz/runtimecore/runtimecore_scripts/scripts"
alias RTC-wikis="cd ~/Development/Quartz/wikis"
alias RTC-tools="cd ~/Development/Quartz/runtimecore/runtimecore_scripts/tools"
alias editrtc="pushd ~/Development/Quartz/runtimecore && nvim && popd"
alias git-clean-rtc="~/.dotfiles/scripts/git_clean_branches_rtc.sh"
alias clang-tidy="~/Development/Quartz/runtimecore/runtimecore_scripts/tools/clang-tidy.sh"

# RTC-script aliases
alias rtc_repos_status="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./get_repos_status.sh -g repos_runtimecore && popd"
alias rtc_create_build="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./create_build.sh && popd"
alias rtc_build_runtimecoretest="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./build.sh -s runtimecore_test && popd"

# RTC Environment script
autoload bashcompinit
bashcompinit
if test -f "~/Development/Quartz/runtimecore/runtimecore_scripts/rtc-env.sh"; then
  source ~/Development/Quartz/runtimecore/runtimecore_scripts/rtc-env.sh
fi

