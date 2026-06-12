param(
    [switch]$InstallTectonic,
    [switch]$ShowFullLatexOptions,
    [string]$InstallDirectory = (Join-Path $env:LOCALAPPDATA "usm-cs-report-template\bin")
)

$forward = @{
    InstallDirectory = $InstallDirectory
}
if ($InstallTectonic) { $forward.InstallTectonic = $true }
if ($ShowFullLatexOptions) { $forward.ShowFullLatexOptions = $true }

& (Join-Path $PSScriptRoot "..\..\skills\latex-runtime-installer\scripts\install-latex-runtime.ps1") @forward
if ($?) { exit 0 }
exit 1
