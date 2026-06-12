---
name: latex-compile
description: Compile LaTeX `.tex` files into PDFs with a portable strategy that tries Tectonic for simple reports and falls back to TeX Live or MiKTeX tools when needed. Use when building, rendering, verifying, or fixing report PDFs.
---

# LaTeX Compile

Use this skill when the user asks to compile, build, render, regenerate, or verify a `.tex` report.

## Workflow

1. Identify the main `.tex` file. If the user points at a folder, prefer `report.tex`, then `main.tex`, then the only `.tex` file if there is exactly one.
2. Run the bundled compiler script:

```powershell
.\scripts\latex-compile.ps1 -Main "C:\path\to\report.tex"
```

Common options:

```powershell
.\scripts\latex-compile.ps1 -Main "C:\path\to\report.tex" -Compiler tectonic
.\scripts\latex-compile.ps1 -Main "C:\path\to\report.tex" -Compiler texlive -Engine xelatex
.\scripts\latex-compile.ps1 -Main "C:\path\to\report.tex" -OutputDirectory "C:\path\to\build"
```

3. If compilation fails, read the first real LaTeX error, edit the `.tex` source, and rerun. Common template issue: underscores in visible placeholders must be escaped or replaced.
4. If no compiler is available, run `latex-doctor` to confirm the gap, then use `latex-runtime-installer` only if the user wants setup help.

## Strategy

- `auto` mode uses Tectonic first for simple reports.
- Projects using bibliography databases, `biber`, indexes, glossaries, `minted`, shell escape, or explicit engine directives go to TeX Live or MiKTeX tooling first.
- TeX Live or MiKTeX builds use `latexmk` when available. Otherwise the selected engine runs twice.

Do not install LaTeX from this skill. Keep setup work in `latex-runtime-installer`.
