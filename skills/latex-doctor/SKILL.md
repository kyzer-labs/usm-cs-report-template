---
name: latex-doctor
description: Detect whether a machine can compile LaTeX reports by checking Tectonic, TeX Live, MiKTeX, latexmk, engines, and a smoke build. Use when preparing a report repo on a new PC, diagnosing missing LaTeX tools, or deciding whether to use latex-compile or latex-runtime-installer.
---

# LaTeX Doctor

Use this skill before compiling on an unfamiliar machine or when a `.tex` build fails because the compiler environment is uncertain.

## Workflow

1. Run the bundled diagnostic script from this skill folder:

```powershell
.\scripts\latex-doctor.ps1
```

For machine-readable output:

```powershell
.\scripts\latex-doctor.ps1 -Json
```

2. Interpret the status:

- `ready`: at least one compiler passed a smoke build. Use `latex-compile`.
- `existing-partial`: at least one compiler-like tool exists but the smoke build failed. Report the exact missing or failing tool.
- `missing`: no usable compiler was detected. Use `latex-runtime-installer` if the user wants setup help.

3. Prefer Tectonic for simple coursework reports. Prefer TeX Live or MiKTeX when a project needs full LaTeX tooling, `latexmk`, custom engines, `biber`, indexes, glossaries, or shell escape.

## Notes

- Do not install anything from this skill.
- Keep the diagnostic output in the final response when reporting machine readiness.
- If the report template compiles but warnings remain, judge success by whether the PDF was produced and opens correctly.
