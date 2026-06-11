# USM CS Report Template

Reusable LaTeX report template for Universiti Sains Malaysia School of Computer Sciences coursework reports.

The template is designed for CS assignments that usually need:

- USM/APEX/School of Computer Sciences cover page
- Table of Contents
- numbered sections like `1.0`, `2.0`, ..., `9.0 References`
- tables, figures, pseudocode, and code snippets
- IEEE-style numbered references

## Quick Start

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
  new-report.ps1
  compile-template.ps1

skills/
  cs-assignment-report-template/
    SKILL.md
    agents/openai.yaml
    assets/
```

The `template/` folder is the canonical human-facing source. The `skills/` folder packages the same template as a Codex skill so agents can infer and apply the workflow automatically.
