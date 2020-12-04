#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

$appdata = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
$rcedit = [Environment]::Is64BitOperatingSystem ? "rcedit-x64" : "rcedit"
$version = (Select-String "version: (\d+(\.\d+){2})" pubspec.yaml).Matches.Groups[1].Value

dart compile exe --output=var/coveralls.exe bin/coveralls.dart
& "$appdata/npm/node_modules/rcedit/bin/$rcedit.exe" var/coveralls.exe `
	--set-icon docs/favicon.ico `
	--set-file-version "$version" `
	--set-product-version "$version" `
	--set-version-string CompanyName "Belin.io" `
	--set-version-string FileDescription "Coveralls for Dart $version" `
	--set-version-string LegalCopyright "Copyright (c) 2017 - 2021 Cédric Belin" `
	--set-version-string OriginalFilename "coveralls.exe" `
	--set-version-string ProductName "Coveralls for Dart"
