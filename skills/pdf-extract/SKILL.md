---
name: pdf-extract
description: Extract structured data (tables, text blocks, form fields) from engineering and municipal PDFs into CSV/JSON. Use for bid tabs, quantity sheets, contract exhibits, agenda packets, and any PDF-to-spreadsheet task. Not for PDF generation or editing.
allowed-tools: Bash, Read, Write
---

# PDF Extract

Converted to official Agent Skills format 2026-07-02 (was a loose .md with unparseable frontmatter). For a full extraction pipeline with schema validation and null-over-guess discipline, dispatch `playbook/agents/data-extractor.md`; this skill is the inline quick version of the same rules.

## Steps

1. Check page count: under 20 pages use the Read tool directly, over 20 use pdf-mcp incremental search (standing rules § pdf-mcp, two-tier strategy).
2. Identify structure (tables, text blocks, form fields) before extracting.
3. MUST use pdfplumber for table extraction, never tabula.
4. pytesseract as OCR fallback for scanned pages only.
5. For scanned PDFs with no text layer, convert pages to images and use Claude vision via the Read tool.
6. Output structured CSV/JSON with headers matching the target schema.
7. Validate row counts and data types before returning. A cell you could not read is null, not a guess.
