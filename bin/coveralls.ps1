#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
dart "$PSScriptRoot/coveralls.dart" @args
