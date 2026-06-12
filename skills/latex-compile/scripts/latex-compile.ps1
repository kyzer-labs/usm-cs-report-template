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

function Resolve-CommandPath {
    param([string]$CommandOrPath)

    if (Test-Path -LiteralPath $CommandOrPath) {
        return (Resolve-Path -LiteralPath $CommandOrPath).Path
    }

    $command = Get-Command $CommandOrPath -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    return $null
}

function Test-RequiresFullLatex {
    param([string]$Path)

    $content = Get-Content -Raw -LiteralPath $Path
    $patterns = @(
        "\\addbibresource",
        "\\bibliography",
        "\\makeindex",
        "\\makeglossaries",
        "\\printglossary",
        "\\usepackage\{minted\}",
        "shell-escape",
        "%\s*!TEX\s+program\s*=\s*(pdfLaTeX|XeLaTeX|LuaLaTeX)"
    )

    foreach ($pattern in $patterns) {
        if ($content -match $pattern) {
            return $true
        }
    }

    return $false
}

function Invoke-Tectonic {
    param(
        [string]$Executable,
        [string]$MainLeaf,
        [string]$MainDir,
        [string]$OutDir
    )

    $pdfName = [System.IO.Path]::GetFileNameWithoutExtension($MainLeaf) + ".pdf"
    $pdfPath = Join-Path $OutDir $pdfName
    Remove-Item -LiteralPath $pdfPath -Force -ErrorAction SilentlyContinue

    Push-Location $MainDir
    try {
        & $Executable -X compile --outdir $OutDir --outfmt pdf --print --untrusted $MainLeaf
        for ($attempt = 0; $attempt -lt 20; $attempt++) {
            if (Test-Path -LiteralPath $pdfPath) {
                return 0
            }
            Start-Sleep -Milliseconds 100
        }
        return $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
}

function Invoke-FullLatex {
    param(
        [string]$MainLeaf,
        [string]$MainDir,
        [string]$OutDir,
        [string]$EngineName
    )

    $latexmk = Get-Command "latexmk" -ErrorAction SilentlyContinue
    Push-Location $MainDir
    try {
        if ($latexmk) {
            $engineFlag = switch ($EngineName) {
                "xelatex" { "-xelatex" }
                "lualatex" { "-lualatex" }
                default { "-pdf" }
            }
            & $latexmk.Source $engineFlag -interaction=nonstopmode -halt-on-error -outdir="$OutDir" $MainLeaf
            return $LASTEXITCODE
        }

        $engineCommand = Get-Command $EngineName -ErrorAction SilentlyContinue
        if (-not $engineCommand) {
            throw "No $EngineName command found. Install Tectonic, TeX Live, or MiKTeX."
        }

        & $engineCommand.Source -interaction=nonstopmode -halt-on-error -output-directory $OutDir $MainLeaf
        if ($LASTEXITCODE -ne 0) {
            return $LASTEXITCODE
        }

        & $engineCommand.Source -interaction=nonstopmode -halt-on-error -output-directory $OutDir $MainLeaf
        return $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
}

$mainPath = Resolve-Path -LiteralPath $Main
$mainDir = Split-Path -Parent $mainPath
$mainLeaf = Split-Path -Leaf $mainPath

if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $mainDir "build"
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$outDirResolved = (Resolve-Path -LiteralPath $OutputDirectory).Path

$needsFullLatex = Test-RequiresFullLatex -Path $mainPath
$tectonic = Resolve-CommandPath -CommandOrPath $TectonicPath
$expectedPdf = Join-Path $outDirResolved ([System.IO.Path]::GetFileNameWithoutExtension($mainLeaf) + ".pdf")

if ($Compiler -eq "tectonic") {
    if (-not $tectonic) {
        throw "Tectonic is not available at '$TectonicPath'."
    }
    $tectonicExit = Invoke-Tectonic -Executable $tectonic -MainLeaf $mainLeaf -MainDir $mainDir -OutDir $outDirResolved
    if ($tectonicExit -eq 0 -or (Test-Path -LiteralPath $expectedPdf)) {
        exit 0
    }
    exit $tectonicExit
}

if ($Compiler -eq "auto" -and $tectonic -and -not $needsFullLatex) {
    $tectonicExit = Invoke-Tectonic -Executable $tectonic -MainLeaf $mainLeaf -MainDir $mainDir -OutDir $outDirResolved
    if ($tectonicExit -eq 0 -or (Test-Path -LiteralPath $expectedPdf)) {
        exit 0
    }
    Write-Warning "Tectonic failed in auto mode; falling back to TeX Live or MiKTeX tooling."
}

exit (Invoke-FullLatex -MainLeaf $mainLeaf -MainDir $mainDir -OutDir $outDirResolved -EngineName $Engine)
