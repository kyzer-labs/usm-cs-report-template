param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE ".agents\skills"),

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourceSkill = Join-Path $repoRoot "skills\cs-assignment-report-template"
$targetSkill = Join-Path $SkillsRoot "cs-assignment-report-template"

if (-not (Test-Path -LiteralPath $sourceSkill)) {
    throw "Bundled skill folder not found: $sourceSkill"
}

if ((Test-Path -LiteralPath $targetSkill) -and -not $Force) {
    throw "Skill already exists at $targetSkill. Re-run with -Force to replace it."
}

New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null

if (Test-Path -LiteralPath $targetSkill) {
    Remove-Item -LiteralPath $targetSkill -Recurse -Force
}

Copy-Item -LiteralPath $sourceSkill -Destination $targetSkill -Recurse -Force

Write-Host "Installed Codex skill:"
Write-Host "  $targetSkill"
Write-Host ""
Write-Host "Start a new Codex session for the refreshed skill list to be picked up."
