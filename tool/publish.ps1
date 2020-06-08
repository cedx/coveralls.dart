#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

tool/clean.ps1
tool/build.ps1
dartfmt --fix --overwrite bin lib test
pub publish --force
