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

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$compileScript = Join-Path $repoRoot "skills\latex-compile\scripts\latex-compile.ps1"

if (-not (Test-Path -LiteralPath $compileScript)) {
    throw "Bundled LaTeX compile script not found: $compileScript"
}

$compileArgs = @{
    Main = $Main
    Compiler = $Compiler
    Engine = $Engine
    TectonicPath = $TectonicPath
}

if ($OutputDirectory) {
    $compileArgs.OutputDirectory = $OutputDirectory
}

& $compileScript @compileArgs
exit $LASTEXITCODE
