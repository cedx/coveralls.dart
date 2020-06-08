#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

pub run build_runner build --delete-conflicting-outputs
pub run test --coverage=var
