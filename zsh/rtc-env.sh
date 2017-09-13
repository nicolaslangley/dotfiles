# Aliases
alias RTC="cd ~/Development/Quartz"
alias RTC-code="cd ~/Development/Quartz/runtimecore"
alias RTC-scripts="cd ~/Development/Quartz/runtimecore_scripts/scripts"
alias RTC-output="cd ~/Development/Quartz/output/macos_x64_debug/bin"
alias editrtc="pushd ~/Development/Quartz/runtimecore && nvim && popd"
alias git-clean-rtc="~/.dotfiles/scripts/git_clean_branches_rtc.sh"
alias qmake-ios="~/Development/Qt/5.6/ios/bin/qmake"
alias qmake-qml-ios-3d-app="~/Development/Qt/5.6/ios/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml_3d/runtimecore_test_qml_3d.pro -r CONFIG+=iphoneos CONFIG+=qml_debug"
alias qmake-qml-android-3d-app="~/Development/Qt/5.6/android_armv7/bin/qmake ~/Development/Quartz/runtimecore/test/runtimecore_test_qml_3d/runtimecore_test_qml_3d.pro -r -spec android-g++ CONFIG+=debug CONFIG+=qml_debug"
alias androiddeployqt="~/Development/Qt/5.6/android_armv7/bin/androiddeployqt"
alias android-qml-deploy="make install INSTALL_ROOT=\"Debug-android\" && ~/Development/Qt/5.6/android_armv7/bin/androiddeployqt --output ./Debug-android/ --deployment bundled --android-platform android-23 --gradle"
alias adb="~/Development/Android/sdk/platform-tools/adb" 


# Exports for Android toolchains
export ANDROID_SDK_ROOT=/Users/nico8506/Development/Android/sdk
export ANDROID_NDK_ROOT=/Users/nico8506/Development/Android/android-ndk-r12b
export ANDROID_TOOLCHAIN_ROOT=/Users/nico8506/Development/Android/android-ndk-r10e/toolchains
export ANDROID_ARMV7=${ANDROID_TOOLCHAIN_ROOT}/android-14_arm-linux-androideabi-4.9/bin
export ANDROID_X86=${ANDROID_TOOLCHAIN_ROOT}/android-14_x86-4.9/bin
export ANDROIDGLES3_ARMV7=${ANDROID_TOOLCHAIN_ROOT}/android-21_arm-linux-androideabi-4.9/bin
export ANDROIDGLES3_ARMV8=${ANDROID_TOOLCHAIN_ROOT}/android-21_aarch64-linux-android-4.9/bin
export ANDROIDGLES3_X86=${ANDROID_TOOLCHAIN_ROOT}/android-21_x86-4.9/bin
export ANDROIDGLES3_X64=${ANDROID_TOOLCHAIN_ROOT}/android-21_x86_64-4.9/bin
