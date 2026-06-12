param(
    [switch]$Json,
    [switch]$SkipSmoke
)

$forward = @{}
if ($Json) { $forward.Json = $true }
if ($SkipSmoke) { $forward.SkipSmoke = $true }

& (Join-Path $PSScriptRoot "..\..\skills\latex-doctor\scripts\latex-doctor.ps1") @forward
if ($?) { exit 0 }
exit 1
