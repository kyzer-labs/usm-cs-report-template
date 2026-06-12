param(
    [switch]$Json,
    [switch]$SkipSmoke
)

$ErrorActionPreference = "Stop"

function Get-ToolInfo {
    param([string]$Name)

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) {
        return [ordered]@{
            name = $Name
            found = $true
            path = $command.Source
        }
    }

    if ($Name -eq "tectonic" -and $env:LOCALAPPDATA) {
        $managedTectonic = Join-Path $env:LOCALAPPDATA "usm-cs-report-template\bin\tectonic.exe"
        if (Test-Path -LiteralPath $managedTectonic) {
            return [ordered]@{
                name = $Name
                found = $true
                path = (Resolve-Path -LiteralPath $managedTectonic).Path
            }
        }
    }

    return [ordered]@{
        name = $Name
        found = $false
        path = $null
    }
}

function Invoke-SmokeBuild {
    param([array]$Tools)

    $compiler = $null
    foreach ($name in @("tectonic", "latexmk", "pdflatex", "xelatex", "lualatex")) {
        $candidate = $Tools | Where-Object { $_.name -eq $name -and $_.found } | Select-Object -First 1
        if ($candidate) {
            $compiler = $candidate
            break
        }
    }

    $result = [ordered]@{
        attempted = $false
        compiler = if ($compiler) { $compiler.name } else { $null }
        ok = $false
        log = $null
    }

    if (-not $compiler) {
        return $result
    }

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("latex-doctor-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    $texPath = Join-Path $tempDir "main.tex"
    @"
\documentclass{article}
\begin{document}
LaTeX smoke test.
\end{document}
"@ | Set-Content -LiteralPath $texPath -Encoding UTF8

    $result.attempted = $true
    Push-Location $tempDir
    try {
        if ($compiler.name -eq "tectonic") {
            $output = & $compiler.path -X compile --outdir $tempDir --outfmt pdf --print --untrusted "main.tex" 2>&1
        }
        elseif ($compiler.name -eq "latexmk") {
            $output = & $compiler.path -pdf -interaction=nonstopmode -halt-on-error -outdir="$tempDir" "main.tex" 2>&1
        }
        else {
            $output = & $compiler.path -interaction=nonstopmode -halt-on-error -output-directory $tempDir "main.tex" 2>&1
        }

        $result.ok = Test-Path -LiteralPath (Join-Path $tempDir "main.pdf")
        $result.log = ($output | Out-String).Trim()
    }
    catch {
        $result.ok = $false
        $result.log = $_.Exception.Message
    }
    finally {
        Pop-Location
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    return $result
}

$toolNames = @("tectonic", "latexmk", "pdflatex", "xelatex", "lualatex", "biber", "kpsewhich")
$tools = @($toolNames | ForEach-Object { Get-ToolInfo $_ })
$foundCompiler = @($tools | Where-Object { $_.found -and $_.name -in @("tectonic", "latexmk", "pdflatex", "xelatex", "lualatex") })
$smoke = if ($SkipSmoke) {
    [ordered]@{
        attempted = $false
        compiler = $null
        ok = $false
        log = "Smoke test skipped."
    }
}
else {
    Invoke-SmokeBuild -Tools $tools
}

$status = if ($smoke.ok) {
    "ready"
}
elseif ($foundCompiler.Count -gt 0) {
    "existing-partial"
}
else {
    "missing"
}

$result = [ordered]@{
    status = $status
    tools = $tools
    smokeTest = $smoke
}

if ($Json) {
    $result | ConvertTo-Json -Depth 6
    exit 0
}

Write-Host "LaTeX status: $status"
Write-Host ""
foreach ($tool in $tools) {
    if ($tool.found) {
        Write-Host ("[found]   {0,-10} {1}" -f $tool.name, $tool.path)
    }
    else {
        Write-Host ("[missing] {0}" -f $tool.name)
    }
}

Write-Host ""
if ($smoke.attempted) {
    $smokeStatus = if ($smoke.ok) { "passed" } else { "failed" }
    Write-Host "Smoke test: $smokeStatus using $($smoke.compiler)"
    if (-not $smoke.ok -and $smoke.log) {
        Write-Host $smoke.log
    }
}
else {
    Write-Host "Smoke test: not attempted"
}
