param(
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [string]$MainFileName = "report.tex",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templateTex = Join-Path $repoRoot "template\report-template.tex"
$logo = Join-Path $repoRoot "template\cover-logo-strip.png"

if (-not (Test-Path -LiteralPath $templateTex)) {
    throw "Template file not found: $templateTex"
}

if (-not (Test-Path -LiteralPath $logo)) {
    throw "Logo strip not found: $logo"
}

$targetPath = New-Item -ItemType Directory -Force -Path $Target
$mainOut = Join-Path $targetPath.FullName $MainFileName
$logoOut = Join-Path $targetPath.FullName "cover-logo-strip.png"

if ((Test-Path -LiteralPath $mainOut) -and -not $Force) {
    throw "Refusing to overwrite existing file: $mainOut. Re-run with -Force if intended."
}

if ((Test-Path -LiteralPath $logoOut) -and -not $Force) {
    throw "Refusing to overwrite existing file: $logoOut. Re-run with -Force if intended."
}

Copy-Item -LiteralPath $templateTex -Destination $mainOut -Force:$Force
Copy-Item -LiteralPath $logo -Destination $logoOut -Force:$Force

Write-Host "Created report template:"
Write-Host "  $mainOut"
Write-Host "  $logoOut"
