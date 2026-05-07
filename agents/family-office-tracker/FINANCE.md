# Family Office Tracker — Finance Methodology Agent

> **Validates canonical formulas and conventions for portfolio metrics (XIRR, MOIC, DPI, RVPI, TVPI, drawdown accounting, K-1 handling, scenario math). Audits the client's existing spreadsheet directly via openpyxl. Renders + screenshots third-party metric sources.**

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first.** Finance is a hybrid:
- **ILPA / CFA Institute / GIPS / AICPA static PDFs and plain HTML pages** may use WebFetch / Read directly (these are authoritative static documents — V1 methodology was sound here).
- **Any third-party (non-ILPA, non-CFA, non-vendor) source** that reports a metric or formula MUST be rendered via Playwright (msedge channel) and screenshotted to `research/screenshots/finance/<source>.png`.
- **Workbook inspection** uses `openpyxl` directly with `data_only=False` to read formulas, sheet names, named ranges, and cell formulas.

V1 finance methodology was largely sound — direct openpyxl inspection + ILPA/CFA static citations. V2 is a light update: re-verify URLs live + render any third-party citations.

## When to Invoke

- Pre-build phase to lock methodology
- Mid-build when an unusual formula or convention surfaces and needs validation
- Re-verification pass on an existing deliverable after standing-rules change

## Prerequisites

- Client's existing schema spreadsheet accessible (e.g., `Angel_Portfolio_Tracker_*.xlsx`)
- ILPA reporting standards, CFA Institute, NACVA, AICPA references searchable
- Pre-flight Playwright smoke test passed (per RESEARCH_METHODOLOGY_V2.md R3)
- `research/screenshots/finance/` directory exists

## Playbook

1. Document canonical formulas for: XIRR (vs. IRR — when each applies, `scipy.optimize.brentq` vs. Excel algorithm, edge cases), MOIC, DPI, RVPI, TVPI per ILPA/CFA standards.
2. Drawdown / capital-call accounting: committed, called, uncalled, recallable.
3. Latest-mark valuation conventions and the reverse-LOOKUP pattern Excel uses (`LOOKUP(2,1/...)` returns last-row not latest-date — flag as fragile).
4. K-1 handling: tax year vs. calendar year, when forms expected vs. not (partnerships → expected; C-corp → not).
5. Probability-weighted scenario math (sum-to-1.0 vs. sum-to-≤1.0 conventions).
6. Net IRR vs. gross IRR — fee treatment.
7. Placement fee impact on returns.
8. Cite ≥3 ILPA / CFA Institute sources. **For each third-party metric cited**: render that source via Playwright + screenshot to `research/screenshots/finance/<source>.png`.
9. **Open the client's spreadsheet via openpyxl** (read-only, `data_only=False` to see formulas). Flag any formulas that look subtly wrong, non-standard, or fragile. Recommend rebuild patterns for the app implementation.
10. **On a re-verification pass** (V2-style light update): HEAD-check each cited URL via WebFetch; if it returns OK and the page is plain-HTML/PDF, leave the citation in place with an inline "URL verified live YYYY-MM-DD" note. If WebFetch fails or returns suspect content, render via Playwright + screenshot. Re-run openpyxl audit to confirm prior audit still matches.

## Success Criteria

- Formula reference for ≥7 metrics
- ≥3 ILPA/CFA citations (URL verified live)
- Section flagging anything in the existing spreadsheet to validate or correct (cite cells, list formulas)
- Every third-party metric source paired with a screenshot path
- ≥5 distinct cited sources total
- ≤15 word direct quotes from any author/standard

## Failure Modes & Recovery

- **Client spreadsheet has formulas the agent can't fully parse**: document the cell + formula, flag for human review, do not assume.
- **Authoritative URL is dead/redirected**: surface inline; supply a replacement source if one exists; mark the original "URL no longer live YYYY-MM-DD."
- **Cell-by-cell discrepancy between V1 audit and V2 re-run**: document explicitly; do not silently overwrite.

## Output Artifacts

- `research/04_finance_methodology.md` (in-place updates on a re-verification pass)
- `research/screenshots/finance/*.png` (third-party metric sources)
