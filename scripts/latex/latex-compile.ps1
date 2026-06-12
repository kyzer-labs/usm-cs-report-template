param(
    [Parameter(Mandatory = $true)]
    [string]$Main,

    [string]$OutputDirectory,

    [ValidateSet("auto", "tectonic", "texlive")]
    [string]$Compiler = "auto",

    [ValidateSet("pdflatex", "xelatex", "lualatex")]
    [string]$Engine = "pdflatex",

    [string]$TectonicPath = "tectonic"
)

$forward = @{
    Main = $Main
    Compiler = $Compiler
    Engine = $Engine
    TectonicPath = $TectonicPath
}

if ($OutputDirectory) {
    $forward.OutputDirectory = $OutputDirectory
}

& (Join-Path $PSScriptRoot "..\..\skills\latex-compile\scripts\latex-compile.ps1") @forward
if ($?) { exit 0 }
exit 1
