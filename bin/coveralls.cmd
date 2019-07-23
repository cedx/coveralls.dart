@echo off
set BASE_DIR=%~dp0
dart.exe "%BASE_DIR:~0,-1%\coveralls.dart" %*
