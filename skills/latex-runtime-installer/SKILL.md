---
name: latex-runtime-installer
description: Help set up a user-level LaTeX compiler for report builds, preferring Tectonic and offering TeX Live or MiKTeX only when needed. Use when latex-doctor reports missing tools or a user asks to install LaTeX support on a new PC.
---

# LaTeX Runtime Installer

Use this skill only after `latex-doctor` shows that the machine cannot compile reports, or when the user explicitly asks to install LaTeX support.

## Workflow

1. Run `latex-doctor` first unless the current diagnostic result is already available.
2. Prefer Tectonic for the report-template workflow. It is small and usually enough for coursework reports.
3. Use the bundled setup helper in detect-only mode first:

```powershell
.\scripts\install-latex-runtime.ps1
```

4. If the user confirms installing Tectonic, run:

```powershell
.\scripts\install-latex-runtime.ps1 -InstallTectonic
```

5. For full LaTeX distributions, do not silently install a multi-GB runtime. Explain the tradeoff and use the official installer path for TeX Live, MacTeX, or MiKTeX based on the OS.

## Safety

- Do not install anything without explicit confirmation.
- Do not remove or overwrite an existing TeX Live, MacTeX, or MiKTeX installation.
- Prefer user-level installs and avoid changing shell startup files.
- After installing, run `latex-doctor`, then compile the report with `latex-compile`.
