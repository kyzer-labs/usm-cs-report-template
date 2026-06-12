# USM CS Report Template

Reusable LaTeX report template for Universiti Sains Malaysia School of Computer Sciences coursework reports, bundled with open Agent Skills and plain PowerShell helpers for diagnosis, compilation, and runtime setup.

The main purpose of this repository is the report template. The LaTeX skills exist so agents and remote PCs can reproduce the full create-and-compile workflow without depending on a specific AI product, hosted integration, or vendor runtime.

The template is designed for CS assignments that usually need:

- USM/APEX/School of Computer Sciences cover page
- Table of Contents
- numbered sections like `1.0`, `2.0`, ..., `9.0 References`
- tables, figures, pseudocode, and code snippets
- IEEE-style numbered references

## Quick Start

Clone the repository:

```powershell
git clone https://github.com/kyzer-labs/usm-cs-report-template.git
cd usm-cs-report-template
```

Create a report copy:

```powershell
.\scripts\new-report.ps1 -Target "C:\CS_USM\Y2S2\COURSE\Assignment"
```

This creates:

```text
Assignment/
  report.tex
  cover-logo-strip.png
```

Then edit the metadata commands near the top of `report.tex`.

## Compile

Compile with the bundled portable compile helper:

```powershell
.\scripts\compile-template.ps1 -Main "C:\path\to\report.tex"
```

The generated PDF is written to a `build/` folder beside the `.tex` file unless another output directory is provided.

The compile helper tries Tectonic first for simple reports and falls back to TeX Live or MiKTeX tooling when needed:

```powershell
.\scripts\compile-template.ps1 -Main "C:\path\to\report.tex" -Compiler auto
.\scripts\compile-template.ps1 -Main "C:\path\to\report.tex" -Compiler tectonic
.\scripts\compile-template.ps1 -Main "C:\path\to\report.tex" -Compiler texlive -Engine xelatex
```

Check a machine's LaTeX readiness:

```powershell
.\scripts\latex\latex-doctor.ps1
```

If no compiler is available, inspect setup options:

```powershell
.\scripts\latex\install-latex-runtime.ps1
```

The installer helper is detect-first. It does not install anything unless explicitly run with an install flag. In install mode it downloads the pinned official Tectonic release declared in `dependencies/tectonic-runtime.json`, verifies the archive SHA-256, and places `tectonic.exe` under `%LOCALAPPDATA%\usm-cs-report-template\bin`. The compile and doctor helpers automatically check that user-level path, so editing `PATH` is optional.

## Agent Skills

The `skills/` folder follows the open Agent Skills layout: each skill is a folder with a required `SKILL.md` plus optional scripts or assets.

Bundled skills:

- `cs-assignment-report-template`
- `latex-doctor`
- `latex-compile`
- `latex-runtime-installer`

Install all bundled skills into the common user-level `.agents` folder:

```powershell
.\scripts\install-skill.ps1
```

Install only one skill:

```powershell
.\scripts\report\install-skills.ps1 -SkillName cs-assignment-report-template
.\scripts\report\install-skills.ps1 -SkillName latex-compile
```

If your agent uses a different skill search path, copy the desired folder from `skills/` into that location. The skills do not require product-specific metadata.

Agents that support the open `skills` npm package can inspect the repository:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --list
```

Use the install command and target flag required by your own agent platform.

## Design Principles

- Report-focused: the template is the main artifact.
- Agent-agnostic: skills are plain `SKILL.md` folders with scripts/assets.
- Runtime-agnostic: scripts prefer Tectonic but can use TeX Live or MiKTeX.
- No product lock-in: no vendor manifest, hosted integration, or account-specific service is required.

## Reference Style

The default reference style is IEEE-style numbered references:

```latex
This claim should be cited \cite{sourceKey}.
```

References are listed in citation order and appear as the final numbered section, for example:

```text
9.0 References
```

Follow the assignment brief or lecturer instructions if they specify another citation format.

## Repository Layout

```text
templates/
  usm-cs-report/
    report-template.tex
    cover-logo-strip.png

examples/
  preview.pdf
  preview-numbered-references.png

scripts/
  new-report.ps1
  compile-template.ps1
  install-skill.ps1
  report/
    new-report.ps1
    compile-template.ps1
    install-skills.ps1
    sync-skill-assets.ps1
  latex/
    latex-doctor.ps1
    latex-compile.ps1
    install-latex-runtime.ps1

skills/
  cs-assignment-report-template/
    SKILL.md
    assets/
  latex-doctor/
    SKILL.md
    scripts/
  latex-compile/
    SKILL.md
    scripts/
  latex-runtime-installer/
    SKILL.md
    scripts/

dependencies/
  tectonic-runtime.json
```

The `templates/` folder is the canonical human-facing source. The report skill packages the same template as skill assets. Run `.\scripts\report\sync-skill-assets.ps1` after changing the canonical template.
