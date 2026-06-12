$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$templateRoot = Join-Path $repoRoot "templates\usm-cs-report"
$skillAssets = Join-Path $repoRoot "skills\cs-assignment-report-template\assets"

New-Item -ItemType Directory -Force -Path $skillAssets | Out-Null

Copy-Item -LiteralPath (Join-Path $templateRoot "report-template.tex") -Destination (Join-Path $skillAssets "cs-assignment-report-template.tex") -Force
Copy-Item -LiteralPath (Join-Path $templateRoot "cover-logo-strip.png") -Destination (Join-Path $skillAssets "cover-logo-strip.png") -Force

Write-Host "Synchronized report template assets into the report skill."
