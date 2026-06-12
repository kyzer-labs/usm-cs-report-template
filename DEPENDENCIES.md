# Dependencies

The report template itself is plain LaTeX plus image assets. The helper scripts are PowerShell scripts intended for Windows-first student and agent workflows.

## Required For Template Use

- PowerShell for the bundled scripts
- A LaTeX compiler to build PDFs

## Supported LaTeX Compilers

- Tectonic: preferred lightweight default for simple coursework reports
- TeX Live or MacTeX: full LaTeX distribution for complex reports
- MiKTeX: Windows-friendly full LaTeX distribution

## Bundled Skills

| Skill | Required | Optional | Notes |
| --- | --- | --- | --- |
| `cs-assignment-report-template` | None beyond file access | LaTeX compiler for verification | Creates report copies from bundled assets. |
| `latex-doctor` | PowerShell | Tectonic, TeX Live, MiKTeX tools | Reports compiler availability and runs a smoke test when possible. |
| `latex-compile` | PowerShell and one LaTeX compiler | `latexmk`, `xelatex`, `lualatex`, `biber` | Tries Tectonic first for simple reports, then falls back to full LaTeX tools. |
| `latex-runtime-installer` | PowerShell and network access for install mode | Tectonic GitHub release access | Detect-first helper. It does not install unless explicitly requested. |

No hosted integration, vendor-specific runtime, or account-specific service is required.
