#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

tool/clean.ps1
tool/build.ps1
dart format --fix --overwrite bin lib test
dart pub publish --force
