param(
    [switch]$InstallTectonic,
    [switch]$ShowFullLatexOptions,
    [string]$InstallDirectory = (Join-Path $env:LOCALAPPDATA "usm-cs-report-template\bin")
)

$ErrorActionPreference = "Stop"

function Test-CommandAvailable {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (Test-CommandAvailable "tectonic") {
    Write-Host "Tectonic is already available on PATH."
    exit 0
}

if (-not $InstallTectonic -and -not $ShowFullLatexOptions) {
    Write-Host "No Tectonic command was found on PATH."
    Write-Host "Run with -InstallTectonic to install a user-level Tectonic binary."
    Write-Host "Run with -ShowFullLatexOptions to print TeX Live and MiKTeX setup links."
    exit 2
}

if ($ShowFullLatexOptions) {
    Write-Host "Full LaTeX distribution options:"
    Write-Host "  TeX Live: https://www.tug.org/texlive/"
    Write-Host "  MiKTeX:   https://miktex.org/download"
    Write-Host "  MacTeX:   https://www.tug.org/mactex/"
}

if (-not $InstallTectonic) {
    exit 0
}

$isWindowsPlatform = ($PSVersionTable.PSEdition -eq "Desktop") -or ($IsWindows -eq $true)
if (-not $isWindowsPlatform) {
    throw "This helper currently installs the Windows Tectonic binary. Use the official Tectonic install instructions on this OS."
}

New-Item -ItemType Directory -Force -Path $InstallDirectory | Out-Null

$release = Invoke-RestMethod -Uri "https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest"
$asset = $release.assets |
    Where-Object { $_.name -match "windows|pc-windows|msvc" -and $_.name -match "\.zip$" } |
    Select-Object -First 1

if (-not $asset) {
    throw "Could not find a Windows Tectonic zip asset in the latest GitHub release."
}

$zipPath = Join-Path ([System.IO.Path]::GetTempPath()) $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
Expand-Archive -LiteralPath $zipPath -DestinationPath $InstallDirectory -Force

$tectonicExe = Get-ChildItem -LiteralPath $InstallDirectory -Recurse -Filter "tectonic.exe" |
    Select-Object -First 1

if (-not $tectonicExe) {
    throw "Downloaded archive did not contain tectonic.exe."
}

$targetExe = Join-Path $InstallDirectory "tectonic.exe"
if ($tectonicExe.FullName -ne $targetExe) {
    Copy-Item -LiteralPath $tectonicExe.FullName -Destination $targetExe -Force
}

Write-Host "Installed Tectonic:"
Write-Host "  $targetExe"
Write-Host ""
Write-Host "Add this folder to PATH before compiling from a new terminal:"
Write-Host "  $InstallDirectory"
