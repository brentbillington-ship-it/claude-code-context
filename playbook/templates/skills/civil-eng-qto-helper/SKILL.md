---
name: civil-eng-qto-helper
description: Use when computing or refining quantity take-offs for civil site plans in Civil 3D / AutoCAD (earthwork volumes, pipe linear feet, pavement area, concrete cubic yards). Do not use for structural take-offs, MEP schedules, or cost estimating — those are different disciplines.
when_to_use: The user mentions quantity take-off, QTO, cut/fill, earthwork, grading volumes, plan-quantity audit, Civil 3D surface comparison, or pipe-network material totals.
allowed-tools: Read, Write, Edit, Bash, Grep
---

# Civil Engineering QTO Helper

Skill scaffold — Brent will fill in Halff-specific conventions (plan-set naming, layer prefixes, unit bases). This body gives Claude the standing procedure.

## Inputs expected

- A plan set exported from Civil 3D as DWG or PDF plan sheets
- A QTO spreadsheet template (openpyxl-writable) with Halff's standard columns
- A scope note saying which sheets / phases to include

## Procedure

1. **Identify the input form.** DWG + autocad-mcp present → use symbol-level access. Plans-only PDF → OCR fallback via pdf-mcp, flag reduced confidence.
2. **Normalize units first.** Halff default is feet and cubic yards; confirm before computing. Wrong units is the top QTO error mode — state the assumed units at the top of every output.
3. **For earthwork:** ask Claude (or autocad-mcp) for the Civil 3D surface-comparison volume report between EX (existing) and PROP (proposed) surfaces. Record cut, fill, net. Apply shrinkage/swell factors only when explicitly instructed.
4. **For pipe networks:** iterate the network by pipe ID, pull length and material, roll up by size + material class.
5. **For pavement / concrete:** compute from polygon areas in the layer prefix Halff uses (to be confirmed — `*PVMT*`, `*CONC*`). Multiply by specified thickness.
6. **Output** as a table matching the QTO spreadsheet columns. Never silently round — report to the precision the source supports.
7. **Flag low-confidence rows** with `[CHECK]` in the notes column. A field-verify flag is better than a wrong subtotal.

## Non-negotiables

- Never fabricate quantities. If a value can't be computed, report `UNKNOWN` + the reason.
- Never alter the source DWG. Read-only dispatch via autocad-mcp.
- Always state the sheet + layer(s) + surface(s) each quantity is derived from.

## Pairs with

- `puran-water/autocad-mcp` for direct Civil 3D dispatch
- `pdf-mcp` for oversized PDF plan-set extraction
- `bw-client-deliverable` skill if producing the QTO as a client deliverable
