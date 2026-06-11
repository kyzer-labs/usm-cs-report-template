---
name: cs-assignment-report-template
description: Use when creating or adapting a reusable LaTeX template for computer science coursework reports, assignment reports, lab reports, project reports, or USM-style student submissions with a cover page, table of contents, body sections, and references.
---

# CS Assignment Report Template

Use this skill when the user asks to create a computer science assignment report in LaTeX, start a report from a reusable `.tex` template, or prepare a report that may later be handed off to DOCX or Google Docs collaborators.

## Workflow

1. Copy `assets/cs-assignment-report-template.tex` into the target project as `report.tex`, `main.tex`, or the filename requested by the user.
2. Copy `assets/cover-logo-strip.png` into the same folder when the user wants the USM/APEX/School of Computer Sciences logo strip. The template still compiles without it by showing a plain text fallback.
3. Fill the metadata commands near the top of the file before editing body content.
4. Keep the report structure simple unless the assignment brief requires otherwise: cover page, table of contents, introduction, objectives, background, methodology, implementation, testing/results, discussion, conclusion, and references. Treat References as the final listed item in the Table of Contents unless the brief requires another final item.
5. If collaboration is needed, treat LaTeX-to-DOCX or LaTeX-to-Google-Docs conversion as a one-way handoff. After the handoff, Google Docs or DOCX should become the final source of truth.
6. If the user asks to compile or verify the report, use the available LaTeX compile workflow and fix errors in the copied project file.

## Reference Style

The template defaults to IEEE-style numbered references. Use in-text citations such as `\cite{sourceKey}`, which render as numbered citations like `[1]`, and list references in citation order. The References page is a numbered final section in the Table of Contents, for example `9.0 References`, unless the assignment brief requires appendices or declarations after it.

Use IEEE-style entries for common source types:

- Article: Author initials and surname, "Article title," *Journal Name*, vol. x, no. y, pp. xx-yy, Month Year, doi: ...
- Website/report: Organization or author, "Page or report title," Month Day, Year. [Online]. Available: URL. [Accessed: Month Day, Year].
- Book: Author initials and surname, *Book Title*, edition. City, Country: Publisher, Year.

If the assignment brief or lecturer specifies APA, Harvard, or another style, follow that requirement instead.

## Template Asset

Template paths:

`assets/cs-assignment-report-template.tex`
`assets/cover-logo-strip.png`

Prefer copying the asset instead of recreating it from memory.
