# Agent Instructions

Use this repository as the source of truth for USM School of Computer Sciences LaTeX report templates.

## Installing The Codex Skill

If the goal is to make this template automatically discoverable by Codex on the local machine, install the bundled skill:

```powershell
.\scripts\install-skill.ps1
```

The script copies `skills/cs-assignment-report-template/` into:

```text
%USERPROFILE%\.agents\skills\cs-assignment-report-template
```

After installation, use a new Codex session so the skill list can refresh. If installing the skill is not appropriate, continue using this repository directly via the workflow below.

## Default Workflow

1. Copy `template/report-template.tex` to the target assignment folder as `report.tex`.
2. Copy `template/cover-logo-strip.png` to the same folder.
3. Fill the metadata commands near the top of `report.tex` using the assignment brief.
4. Keep the section list as a starting reference, not a rule. Rename, add, or remove sections to match the actual brief.
5. Keep `References` as the final numbered section in the Table of Contents unless the brief requires appendices or declarations after it.
6. Use IEEE-style numbered citations by default: `\cite{sourceKey}`.
7. Compile and verify the PDF after edits.

## Preferred Commands

Install the Codex skill globally:

```powershell
.\scripts\install-skill.ps1
```

Create a report copy:

```powershell
.\scripts\new-report.ps1 -Target "C:\path\to\assignment"
```

Compile a report:

```powershell
.\scripts\compile-template.ps1 -Main "C:\path\to\assignment\report.tex"
```

## Editing Notes

- Do not edit generated PDFs as the source of truth.
- Prefer changing `template/report-template.tex`, then mirror material changes into `skills/cs-assignment-report-template/assets/cs-assignment-report-template.tex`.
- Keep the Codex skill concise. Put reusable files in `assets/`, not in long instructions.
- If the lecturer specifies a different cover, citation style, section order, or declaration page, follow the lecturer's brief.
