# Agent Instructions

Use this repository as the source of truth for USM School of Computer Sciences LaTeX report templates. The report template is the primary product; the bundled LaTeX skills are portable support tooling for agents and machines that do not already have a LaTeX workflow.

## Package Shape

- Primary workflow: create and compile a USM CS LaTeX report.
- Primary skill: `skills/cs-assignment-report-template/`
- Supporting skills: `skills/latex-doctor/`, `skills/latex-compile/`, `skills/latex-runtime-installer/`
- Skill format: open Agent Skills style folders with `SKILL.md`, optional scripts, and optional assets.
- Product-specific packaging metadata and hosted integrations are intentionally not included.

## Installing Skills

Install all bundled skills globally for agents that read `%USERPROFILE%\.agents\skills`:

```powershell
.\scripts\install-skill.ps1
```

Install a single skill:

```powershell
.\scripts\report\install-skills.ps1 -SkillName cs-assignment-report-template
.\scripts\report\install-skills.ps1 -SkillName latex-compile
```

For other agents, copy the relevant folder under `skills/` into that agent's skill search path.

Agents that support the open `skills` npm package can inspect the available skills:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --list
```

Use the install command and target flag required by the specific agent platform.

## Default Report Workflow

1. Copy `templates/usm-cs-report/report-template.tex` to the target assignment folder as `report.tex`.
2. Copy `templates/usm-cs-report/cover-logo-strip.png` to the same folder.
3. Fill the metadata commands near the top of `report.tex` using the assignment brief.
4. Keep the section list as a starting reference, not a rule. Rename, add, or remove sections to match the actual brief.
5. Keep `References` as the final numbered section in the Table of Contents unless the brief requires appendices or declarations after it.
6. Use IEEE-style numbered citations by default: `\cite{sourceKey}`.
7. Compile and verify the PDF after edits.

Use the helper script for steps 1 and 2:

```powershell
.\scripts\new-report.ps1 -Target "C:\path\to\assignment"
```

Compile:

```powershell
.\scripts\compile-template.ps1 -Main "C:\path\to\assignment\report.tex"
```

Diagnose LaTeX tooling:

```powershell
.\scripts\latex\latex-doctor.ps1
```

## Editing Notes

- Do not edit generated PDFs as the source of truth.
- Prefer changing `templates/usm-cs-report/report-template.tex`.
- After changing the canonical template, run `.\scripts\report\sync-skill-assets.ps1`.
- Keep skills concise. Put reusable files in `assets/` or `scripts/`, not in long instructions.
- If the lecturer specifies a different cover, citation style, section order, or declaration page, follow the lecturer's brief.
- Do not run runtime installers unless the user explicitly asks to install LaTeX support.
