param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE ".agents\skills"),

    [string]$SkillName = "all",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$sourceSkillsRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $sourceSkillsRoot)) {
    throw "Bundled skills folder not found: $sourceSkillsRoot"
}

$skills = if ($SkillName -eq "all" -or $SkillName -eq "*") {
    Get-ChildItem -LiteralPath $sourceSkillsRoot -Directory
}
else {
    $candidate = Join-Path $sourceSkillsRoot $SkillName
    if (-not (Test-Path -LiteralPath $candidate)) {
        throw "Bundled skill not found: $SkillName"
    }
    Get-Item -LiteralPath $candidate
}

New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null

foreach ($skill in $skills) {
    $targetSkill = Join-Path $SkillsRoot $skill.Name

    if ((Test-Path -LiteralPath $targetSkill) -and -not $Force) {
        throw "Skill already exists at $targetSkill. Re-run with -Force to replace it."
    }

    if (Test-Path -LiteralPath $targetSkill) {
        Remove-Item -LiteralPath $targetSkill -Recurse -Force
    }

    Copy-Item -LiteralPath $skill.FullName -Destination $targetSkill -Recurse -Force

    Write-Host "Installed agent skill:"
    Write-Host "  $targetSkill"
}

Write-Host ""
Write-Host "Start a new agent session for the refreshed skill list to be picked up."
