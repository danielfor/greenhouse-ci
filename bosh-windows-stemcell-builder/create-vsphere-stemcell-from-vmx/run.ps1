﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

New-Item -ItemType Directory -Force -Path $env:VMX_CACHE_DIR

Write-Host "Copying stembuild (${PWD}\stembuild\stembuild-windows-x86_64-*.exe) to: ${PWD}\bin\stembuild.exe"
mkdir "${PWD}\bin"
mv "${PWD}\stembuild\stembuild-windows-x86_64-*.exe" "${PWD}\bin\stembuild.exe"

$env:PATH="${PWD}\bin;$env:PATH"

cd "stemcell-builder"
bundle install
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not bundle install"
  Exit 1
}
rake package:agent
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not package agent"
  Exit 1
}
rake package:psmodules
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not package psmodules"
  Exit 1
}
rake build:vsphere
if ($LASTEXITCODE -ne 0) {
  Write-Error "Could not build vsphere"
  Exit 1
}
