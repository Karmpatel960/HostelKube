@echo off

REM Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
set PATH=%PATH%;%cd%\flutter\bin
flutter precache

REM Build the Flutter web app
flutter build web
