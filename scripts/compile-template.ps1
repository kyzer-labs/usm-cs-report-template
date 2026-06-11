param(
    [Parameter(Mandatory = $true)]
    [string]$Main,

    [string]$OutputDirectory,

    [string]$TectonicPath = "tectonic"
)

$ErrorActionPreference = "Stop"

$mainPath = Resolve-Path -LiteralPath $Main
$mainDir = Split-Path -Parent $mainPath

if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $mainDir "build"
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

$tectonic = Get-Command $TectonicPath -ErrorAction SilentlyContinue

if ($tectonic) {
    Push-Location $mainDir
    try {
        & $tectonic.Source -X compile --outdir $OutputDirectory --outfmt pdf --print --untrusted (Split-Path -Leaf $mainPath)
    }
    finally {
        Pop-Location
    }
    exit $LASTEXITCODE
}

$pdflatex = Get-Command "pdflatex" -ErrorAction SilentlyContinue

if ($pdflatex) {
    Push-Location $mainDir
    try {
        & $pdflatex.Source -interaction=nonstopmode -halt-on-error -output-directory $OutputDirectory (Split-Path -Leaf $mainPath)
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        & $pdflatex.Source -interaction=nonstopmode -halt-on-error -output-directory $OutputDirectory (Split-Path -Leaf $mainPath)
    }
    finally {
        Pop-Location
    }
    exit $LASTEXITCODE
}

throw "No LaTeX compiler found. Install Tectonic or TeX Live/MiKTeX, or pass -TectonicPath."
