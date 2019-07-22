@echo off
set BASE_DIR=%~dp0
dart.exe "%BASE_DIR%\coveralls.dart" %*
