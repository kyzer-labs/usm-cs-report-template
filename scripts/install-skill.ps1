param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE ".agents\skills"),

    [string]$SkillName = "all",

    [switch]$Force
)

$forward = @{
    SkillsRoot = $SkillsRoot
    SkillName = $SkillName
}
if ($Force) { $forward.Force = $true }

& (Join-Path $PSScriptRoot "report\install-skills.ps1") @forward
if ($?) { exit 0 }
exit 1
