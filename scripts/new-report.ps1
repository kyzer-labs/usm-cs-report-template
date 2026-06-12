param(
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [string]$MainFileName = "report.tex",

    [switch]$Force
)

$forward = @{
    Target = $Target
    MainFileName = $MainFileName
}
if ($Force) { $forward.Force = $true }

& (Join-Path $PSScriptRoot "report\new-report.ps1") @forward
if ($?) { exit 0 }
exit 1
