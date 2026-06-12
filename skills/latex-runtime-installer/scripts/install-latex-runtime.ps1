param(
    [switch]$InstallTectonic,
    [switch]$ShowFullLatexOptions,
    [string]$InstallDirectory,
    [string]$RuntimeMetadataPath
)

$ErrorActionPreference = "Stop"

function Test-CommandAvailable {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Get-DefaultInstallDirectory {
    if (-not $env:LOCALAPPDATA) {
        return $null
    }

    return (Join-Path $env:LOCALAPPDATA "usm-cs-report-template\bin")
}

function Get-ManagedTectonicPath {
    param([string]$Directory)
    return (Join-Path $Directory "tectonic.exe")
}

function Get-RuntimeMetadataCandidates {
    $paths = @()

    if ($RuntimeMetadataPath) {
        $paths += $RuntimeMetadataPath
    }

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..") -ErrorAction SilentlyContinue
    if ($repoRoot) {
        $paths += (Join-Path $repoRoot.Path "dependencies\tectonic-runtime.json")
    }

    $skillRoot = Resolve-Path (Join-Path $PSScriptRoot "..") -ErrorAction SilentlyContinue
    if ($skillRoot) {
        $paths += (Join-Path $skillRoot.Path "dependencies\tectonic-runtime.json")
    }

    return @($paths | Select-Object -Unique)
}

function Read-TectonicRuntimeMetadata {
    foreach ($candidate in Get-RuntimeMetadataCandidates) {
        if (Test-Path -LiteralPath $candidate) {
            $metadata = Get-Content -Raw -LiteralPath $candidate | ConvertFrom-Json
            if (-not $metadata.windows.assetUrl -or -not $metadata.windows.assetName -or -not $metadata.windows.sha256) {
                throw "Runtime metadata is missing windows.assetUrl, windows.assetName, or windows.sha256: $candidate"
            }
            $metadata | Add-Member -NotePropertyName "_path" -NotePropertyValue $candidate -Force
            return $metadata
        }
    }

    throw "Could not find dependencies\tectonic-runtime.json. Pass -RuntimeMetadataPath to a pinned runtime metadata file."
}

if (-not $InstallDirectory) {
    $InstallDirectory = Get-DefaultInstallDirectory
}

$managedTectonic = if ($InstallDirectory) { Get-ManagedTectonicPath -Directory $InstallDirectory } else { $null }

if ((Test-CommandAvailable "tectonic") -and -not $InstallTectonic -and -not $ShowFullLatexOptions) {
    Write-Host "Tectonic is already available on PATH."
    exit 0
}

if ($managedTectonic -and (Test-Path -LiteralPath $managedTectonic) -and -not $InstallTectonic -and -not $ShowFullLatexOptions) {
    Write-Host "Tectonic is already available at the user-level runtime path."
    Write-Host "  $managedTectonic"
    exit 0
}

if (-not $InstallTectonic -and -not $ShowFullLatexOptions) {
    Write-Host "No Tectonic command was found on PATH."
    if ($managedTectonic) {
        Write-Host "No user-level Tectonic binary was found at:"
        Write-Host "  $managedTectonic"
    }
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

if (-not $InstallDirectory) {
    throw "LOCALAPPDATA is not set. Pass -InstallDirectory explicitly."
}

New-Item -ItemType Directory -Force -Path $InstallDirectory | Out-Null

$metadata = Read-TectonicRuntimeMetadata
$assetName = [string]$metadata.windows.assetName
$assetUrl = [string]$metadata.windows.assetUrl
$expectedSha256 = ([string]$metadata.windows.sha256).ToLowerInvariant()

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("usm-cs-report-template-tectonic-" + [System.Guid]::NewGuid().ToString("N"))
$extractRoot = Join-Path $tempRoot "extract"
$zipPath = Join-Path $tempRoot $assetName

New-Item -ItemType Directory -Force -Path $extractRoot | Out-Null

try {
    Write-Host "Installing pinned Tectonic runtime:"
    Write-Host "  version: $($metadata.version)"
    Write-Host "  asset:   $assetName"
    Write-Host "  source:  $assetUrl"
    Write-Host "  pin:     $($metadata._path)"

    Invoke-WebRequest -Uri $assetUrl -OutFile $zipPath

    $actualSha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash.ToLowerInvariant()
    if ($actualSha256 -ne $expectedSha256) {
        throw "Checksum mismatch for $assetName. Expected $expectedSha256 but got $actualSha256."
    }

    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractRoot -Force

    $tectonicExe = Get-ChildItem -LiteralPath $extractRoot -Recurse -Filter "tectonic.exe" |
        Select-Object -First 1

    if (-not $tectonicExe) {
        throw "Downloaded archive did not contain tectonic.exe."
    }

    $targetExe = Join-Path $InstallDirectory "tectonic.exe"
    Copy-Item -LiteralPath $tectonicExe.FullName -Destination $targetExe -Force

    $installRecord = [ordered]@{
        name = $metadata.name
        version = $metadata.version
        releaseTag = $metadata.releaseTag
        assetName = $assetName
        assetUrl = $assetUrl
        sha256 = $expectedSha256
        installedAt = (Get-Date).ToUniversalTime().ToString("o")
    }
    $installRecordPath = Join-Path $InstallDirectory "tectonic-runtime.json"
    $installRecord | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $installRecordPath -Encoding UTF8

    Write-Host "Installed Tectonic:"
    Write-Host "  $targetExe"
    Write-Host ""
    Write-Host "The bundled compile helpers automatically check this path. Add this folder to PATH only if other tools need it:"
    Write-Host "  $InstallDirectory"
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
