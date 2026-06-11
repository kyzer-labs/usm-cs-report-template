# USM CS Report Template

Reusable LaTeX report template for Universiti Sains Malaysia School of Computer Sciences coursework reports.

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

Copy the template into an assignment folder:

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

## Install For Codex Agents

Because this repository is public, the fastest install path is the open `skills` npm package.

Install the skill for Codex in the current project:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill cs-assignment-report-template --agent codex --copy -y
```

Install it globally through the same package:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --skill cs-assignment-report-template --agent codex --global --copy -y
```

List the skills discovered from this repository without installing:

```powershell
npx skills add https://github.com/kyzer-labs/usm-cs-report-template --list
```

Requirements for the `npx` flow:

- Node.js/npm must be installed.
- The machine must be able to access GitHub.
- Restart Codex if the installed skill does not appear immediately.

For a Codex App global install on Windows, this repository also includes a local installer that copies the bundled skill to the user-level `.agents` folder:

```powershell
.\scripts\install-skill.ps1
```

This installs the skill to:

```text
%USERPROFILE%\.agents\skills\cs-assignment-report-template
```

After installation, start a new Codex session. Future sessions should be able to infer the skill from requests like:

```text
Create a LaTeX report for my CS assignment.
```

Or invoke it explicitly:

```text
Use $cs-assignment-report-template to start a report.
```

For non-Codex agents, use `AGENTS.md` and the `template/` folder directly.

## Compile

If Tectonic is installed:

```powershell
.\scripts\compile-template.ps1 -Main "C:\path\to\report.tex"
```

The generated PDF is written to a `build/` folder beside the `.tex` file unless another output directory is provided.

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
template/
  report-template.tex
  cover-logo-strip.png

examples/
  preview.pdf
  preview-numbered-references.png

scripts/
  install-skill.ps1
  new-report.ps1
  compile-template.ps1

skills/
  cs-assignment-report-template/
    SKILL.md
    agents/openai.yaml
    assets/
```

The `template/` folder is the canonical human-facing source. The `skills/` folder packages the same template as a Codex skill so agents can infer and apply the workflow automatically.
