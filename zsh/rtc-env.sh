# RTC specific aliases

# Directory aliases
alias RTC="cd ~/Development/Quartz"
alias RTC-code="cd ~/Development/Quartz/runtimecore"
alias RTC-mr3d-dir="cd ~/Development/Quartz/runtimecore/map_renderer_3d"
alias RTC-mr3d-pipeline="cd ~/Development/Quartz/runtimecore/map_renderer_3d/src/graphics_pipeline3d"
alias RTC-mr3d-low-level="cd ~/Development/Quartz/runtimecore/map_renderer_3d/src/graphics_pipeline3d/low_level_renderer"
alias RTC-scripts="cd ~/Development/Quartz/runtimecore_scripts/scripts"
alias RTC-output="cd ~/Development/Quartz/output/macos_x64_debug/bin"
alias editrtc="pushd ~/Development/Quartz/runtimecore && nvim && popd"
alias git_clean_rtc="~/.dotfiles/scripts/git_clean_branches_rtc.sh"

# Android NDK and Toolchains
alias adb="~/Development/Android/sdk/platform-tools/adb" 
export ANDROID_SDK_ROOT=/Users/nico8506/Development/Android/sdk
export ANDROID_NDK_ROOT=/Users/nico8506/Development/Android/android-ndk-r12b
export ANDROID_TOOLCHAIN_ROOT=/Users/nico8506/Development/Android/android-ndk-r10e/toolchains
export ANDROID_ARMV7=${ANDROID_TOOLCHAIN_ROOT}/android-14_arm-linux-androideabi-4.9/bin
export ANDROID_X86=${ANDROID_TOOLCHAIN_ROOT}/android-14_x86-4.9/bin
export ANDROIDGLES3_ARMV7=${ANDROID_TOOLCHAIN_ROOT}/android-21_arm-linux-androideabi-4.9/bin
export ANDROIDGLES3_ARMV8=${ANDROID_TOOLCHAIN_ROOT}/android-21_aarch64-linux-android-4.9/bin
export ANDROIDGLES3_X86=${ANDROID_TOOLCHAIN_ROOT}/android-21_x86-4.9/bin
export ANDROIDGLES3_X64=${ANDROID_TOOLCHAIN_ROOT}/android-21_x86_64-4.9/bin
export PATH=${PATH}:${ANDROIDGLES3_ARMV7}:${ANDROIDGLES3_ARMV8}:${ANDROIDGLES3_X86}:${ANDROIDGLES3_X64}

# Qt
alias qmake-ios="~/Development/Qt/5.9.2/ios/bin/qmake"
alias qmake-android="~/Development/Qt/5.9.2/android_armv7/bin/qmake"
alias qmake-mac-qml-app="qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml/runtimecore_test_qml.pro -r CONFIG+=debug"
alias qmake-qml-ios-3d-app="~/Development/Qt/5.9.2/ios/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml_3d/runtimecore_test_qml_3d.pro -r CONFIG+=iphoneos CONFIG+=qml_debug"
alias qmake-qml-android-3d-app="~/Development/Qt/5.9.2/android_armv7/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml_3d/runtimecore_test_qml_3d.pro -r -spec android-g++ CONFIG+=debug CONFIG+=qml_debug"
alias androiddeployqt="~/Development/Qt/5.9.2/android_armv7/bin/androiddeployqt"
output_dir=android-qml3d-build
alias android-qml-deploy="make install INSTALL_ROOT=\"$output_dir\" && ~/Development/Qt/5.9.2/android_armv7/bin/androiddeployqt --output ./$output_dir/ --deployment bundled --android-platform android-26 --jdk /Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home --gradle"

# RTC-script aliases
alias rtc_repos_status="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./get_repos_status.sh -g repos_runtimecore && popd"
alias rtc_create_build="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./create_build.sh && popd"
alias rtc_build_runtimecoretest="cd ~/Development/Quartz/runtimecore_scripts/scripts && ./build.sh -s runtimecore_test && popd"

# Switch between clang command line tools OS X
alias clang-command-line="sudo xcode-select --switch /Library/Developer/CommandLineTools/"
alias clang-xcode="sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/"
