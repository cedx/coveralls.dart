#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

dart pub run coverage:format_coverage --in=var/test --lcov --out=var/lcov.info --packages=.dart_tool/package_config.json --report-on=lib
dart bin/coveralls.dart var/lcov.info
