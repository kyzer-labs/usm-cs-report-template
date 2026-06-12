# USM CS Report Template

Reusable LaTeX report template for Universiti Sains Malaysia School of Computer Sciences coursework reports, bundled with lightweight agent skills for LaTeX diagnosis, compilation, and runtime setup.

The main purpose of this repository is still the report template. The LaTeX skills exist so agents and remote PCs can reproduce the full create-and-compile workflow even when Codex's bundled LaTeX plugin is not available.

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

The installer helper is detect-first. It does not install anything unless explicitly run with an install flag.

## Install For Agents

Install all bundled skills into the user-level `.agents` folder:

```powershell
.\scripts\install-skill.ps1
```

This installs:

- `cs-assignment-report-template`
- `latex-doctor`
- `latex-compile`
- `latex-runtime-installer`

Install only one skill:

```powershell
.\scripts\report\install-skills.ps1 -SkillName cs-assignment-report-template
.\scripts\report\install-skills.ps1 -SkillName latex-compile
```

Because this repository is public, agents that support the open `skills` npm package can also install individual skills directly from GitHub:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill cs-assignment-report-template --agent codex --copy -y
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill latex-doctor --agent codex --copy -y
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill latex-compile --agent codex --copy -y
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill latex-runtime-installer --agent codex --copy -y
```

List discovered skills without installing:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --list
```

Restart the agent or start a new session after installing skills if they do not appear immediately.

For non-Codex agents, use `AGENTS.md`, `templates/usm-cs-report/`, and the PowerShell scripts directly.

## Codex Plugin Manifest

This repository includes a Codex plugin manifest at:

```text
.codex-plugin/plugin.json
```

The manifest points at `./skills/` and contains no connector apps or MCP servers. It exists so the same repo can be used as a report-template skill source, a local plugin package, or a plain script/template repository.

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
.codex-plugin/
  plugin.json

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
  latex-doctor/
  latex-compile/
  latex-runtime-installer/
```

The `templates/` folder is the canonical human-facing source. The report skill packages the same template as skill assets. Run `.\scripts\report\sync-skill-assets.ps1` after changing the canonical template.
