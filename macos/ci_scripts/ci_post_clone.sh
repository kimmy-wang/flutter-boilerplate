#!/bin/sh

echo "🟩 Navigate from ($PWD) to ($CI_WORKSPACE)"
cd $CI_WORKSPACE

echo "🟩 Install Flutter"
time git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

echo "🟩 Flutter Precache"
time flutter precache --ios

echo "🟩 Install Flutter Dependencies"
time flutter pub get

echo "🟩 Install CocoaPods via Homebrew"
time HOMEBREW_NO_AUTO_UPDATE=1 brew install -q cocoapods

echo "🟩 Install CocoaPods dependencies..."
time cd ios && pod install --silent

exit 0
