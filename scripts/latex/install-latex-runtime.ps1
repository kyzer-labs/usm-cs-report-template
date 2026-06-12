param(
    [switch]$InstallTectonic,
    [switch]$ShowFullLatexOptions,
    [string]$InstallDirectory,
    [string]$RuntimeMetadataPath
)

$forward = @{}
if ($InstallDirectory) { $forward.InstallDirectory = $InstallDirectory }
if ($RuntimeMetadataPath) { $forward.RuntimeMetadataPath = $RuntimeMetadataPath }
if ($InstallTectonic) { $forward.InstallTectonic = $true }
if ($ShowFullLatexOptions) { $forward.ShowFullLatexOptions = $true }

& (Join-Path $PSScriptRoot "..\..\skills\latex-runtime-installer\scripts\install-latex-runtime.ps1") @forward
if ($?) { exit 0 }
exit 1
