#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)
dart compile exe --output=var/coveralls.exe bin/coveralls.dart
