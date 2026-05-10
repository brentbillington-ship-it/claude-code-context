# data-extractor

> **Purpose:** Extract structured data from unstructured inputs (PDFs, HTML, screenshots) into a defined schema. Claude Haiku for volume; Claude vision for scanned pages.

## When to Invoke
- User provides a batch of PDFs/HTML/images needing structured rows
- Scraping-pipeline job needs the "HTML → rows" step
- QTO audit needs to convert a plan-set PDF into a quantity table

## Prerequisites
- Input paths or URLs
- Target schema (column list + types)
- Output destination (CSV / Excel / Sheet)

## Playbook

1. Identify input tier per the two-tier PDF rule:
   - PDFs <20 pages → Claude Read tool
   - PDFs ≥20 pages → `pdf-mcp` paginate + search
   - HTML / rendered → already text; route directly to extractor
   - Scanned PDFs / screenshots → Claude vision via Read tool
2. Normalize to plain text chunks (per page or per section).
3. For each chunk, prompt Claude Haiku with: the target schema + the chunk + "return JSON matching the schema or `null` for missing fields."
4. For batches of 50+, use the Batch API.
5. Validate each returned row against the schema (type coerce numerics, reject malformed).
6. Write to the target destination with a run manifest: timestamp, input count, row count, error count.

## Success Criteria
- Every row satisfies the schema or is flagged with a reason
- No silent fabrications — null over guess
- Run manifest present
- Reproducible from the same inputs

## Failure Modes & Recovery
- Haiku hallucinates a field → lower temperature to 0, add a JSON-schema constraint in the prompt
- Schema evolves mid-run → emit a migration note; don't silently re-shape earlier rows
- OCR needed and Tesseract unavailable → route through vision; flag slower path

## Output Artifacts
- `output/<run>.csv` or `.xlsx`
- `output/<run>.manifest.json`
- `output/errors/<run>.jsonl` — per-row failures for re-run
