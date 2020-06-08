#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

tool/clean.ps1
pub run build_runner build --delete-conflicting-outputs
dartfmt --fix --overwrite bin lib test
pub publish --force
