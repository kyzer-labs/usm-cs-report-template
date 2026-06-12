# Dependencies

The report template itself is plain LaTeX plus image assets. The helper scripts are PowerShell scripts intended for Windows-first student and agent workflows.

## Required For Template Use

- PowerShell for the bundled scripts
- A LaTeX compiler to build PDFs

## Supported LaTeX Compilers

- Tectonic: preferred lightweight default for simple coursework reports
- TeX Live or MacTeX: full LaTeX distribution for complex reports
- MiKTeX: Windows-friendly full LaTeX distribution

## Pinned Tectonic Runtime

The optional Windows Tectonic installer uses `dependencies/tectonic-runtime.json` instead of a floating latest release. The metadata pins Tectonic `0.16.9`, the official Windows x86_64 MSVC ZIP asset, and the expected SHA-256 hash. Install mode downloads that release asset, verifies the hash, then copies only `tectonic.exe` into `%LOCALAPPDATA%\usm-cs-report-template\bin`.

Do not commit compiler binaries. When updating the runtime pin, update both metadata copies:

- `dependencies/tectonic-runtime.json`
- `skills/latex-runtime-installer/dependencies/tectonic-runtime.json`

## Bundled Skills

| Skill | Required | Optional | Notes |
| --- | --- | --- | --- |
| `cs-assignment-report-template` | None beyond file access | LaTeX compiler for verification | Creates report copies from bundled assets. |
| `latex-doctor` | PowerShell | Tectonic, TeX Live, MiKTeX tools | Reports compiler availability, including the user-level Tectonic path, and runs a smoke test when possible. |
| `latex-compile` | PowerShell and one LaTeX compiler | `latexmk`, `xelatex`, `lualatex`, `biber` | Tries Tectonic first for simple reports, including the user-level runtime path, then falls back to full LaTeX tools. |
| `latex-runtime-installer` | PowerShell and network access for install mode | Tectonic GitHub release access | Detect-first helper. It installs only when explicitly requested and verifies the pinned Tectonic archive checksum. |

No hosted integration, vendor-specific runtime, or account-specific service is required.
