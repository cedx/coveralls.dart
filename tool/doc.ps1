#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

dartdoc --favicon=doc/img/favicon.ico
mkdocs build --config-file=etc/mkdocs.yaml
