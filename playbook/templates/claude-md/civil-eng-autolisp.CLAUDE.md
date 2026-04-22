# CLAUDE.md — Civil Engineering / AutoLISP / Civil 3D

## Halff project. Zero Billington Works branding.

## Build / Run

```
# AutoLISP quick-load (in AutoCAD / Civil 3D command line)
(load "project.lsp")
# Dispatch from repo via autocad-mcp (if installed)
# → claude invokes autocad-mcp tool directly
py -m tools.qto_audit        # QTO audit driver (reads plan set, writes Excel)
```

Units: feet and cubic yards (Halff default). Confirm before computing any quantity.

---

## Prime rules

1. MUST NOT include Billington Works branding. This is a Halff deliverable.
2. MUST NOT fabricate PE-sealed content, stamp blocks, or seals.
3. MUST use `autocad-mcp` for DWG read — never parse DWG bytes directly.
4. MUST report units at the top of any computed quantity output.
5. MUST flag low-confidence QTO rows with `[CHECK]` instead of silently rounding.

---

## Stack

- CAD: AutoCAD LT / Civil 3D
- LISP: classic AutoLISP; no Visual LISP object model unless unavoidable
- QTO: Python with `openpyxl` + `autocad-mcp`
- PDF plan sets: `pdf-mcp` for >20 pages, Read tool for smaller sets (two-tier rule)

## File layout

```
lsp/
├── project.lsp          # main loader
├── modules/*.lsp
└── README.md            # plain LISP docs
python/
├── tools/
│   ├── qto_audit.py
│   └── plan_scan.py
└── requirements.txt
docs/
├── plan_set_2026-XX.pdf
└── QTO_template.xlsx
.claude/skills/
└── civil-eng-qto-helper/SKILL.md
```

## Halff conventions (confirm per job)

- Layer prefix conventions: `EX-*` existing, `PROP-*` proposed, `DEMO-*` demolition
- Filename prefix: Halff project number + phase code
- Surface naming: `EX_SURF`, `PROP_SURF` for Civil 3D surface compare
- Unit style: engineering (feet + decimal inches for small dims)

## What NOT to do

- Don't alter source DWGs. Read-only dispatch through `autocad-mcp`.
- Don't write back to a DWG without an explicit user approval + backup copy.
- Don't guess at QTO quantities. UNKNOWN + reason > wrong number.
- Don't ship a Halff deliverable with a linked Billington Works template or CSS.

## Last 5 lines — pre-deliverable

- Brand audit: `halff-brand-compliance` skill run + all PASS?
- Units stated on every quantity?
- Source sheet/layer cited per row?
- `[CHECK]` flags reviewed?
- PE seal: either absent or affixed by the actual licensed engineer?
