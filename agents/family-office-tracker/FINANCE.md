# Family Office Tracker — Finance Methodology Agent

> **Validates canonical formulas and conventions for portfolio metrics (XIRR, MOIC, DPI, RVPI, TVPI, drawdown accounting, K-1 handling, scenario math). Cross-checks against the client's existing spreadsheet.**

## When to Invoke

- Pre-build phase to lock methodology
- Mid-build when an unusual formula or convention surfaces and needs validation

## Prerequisites

- Client's existing schema spreadsheet accessible
- ILPA reporting standards, CFA Institute, NACVA, AICPA references searchable

## Playbook

1. Document canonical formulas for: XIRR (vs. IRR — when each applies, scipy.optimize.brentq vs. Excel algorithm, edge cases), MOIC, DPI, RVPI, TVPI per ILPA/CFA standards.
2. Drawdown / capital call accounting: committed, called, uncalled, recallable.
3. Latest-mark valuation conventions and the reverse-LOOKUP pattern Excel uses (LOOKUP(2,1/...)).
4. K-1 handling: tax year vs. calendar year, when forms expected vs. not.
5. Probability-weighted scenario math.
6. Net IRR vs. gross IRR — fee treatment.
7. Placement fee impact on returns.
8. Cite ≥3 ILPA / CFA Institute sources.
9. Open the client's spreadsheet (read-only). Flag any formulas that look subtly wrong, non-standard, or fragile (e.g., the LOOKUP-based latest-mark pattern). Recommend rebuild patterns for the app implementation.

## Success Criteria

- Formula reference for ≥7 metrics
- ≥3 ILPA/CFA citations
- Section flagging anything in the existing spreadsheet to validate or correct
- ≥5 distinct cited sources total

## Failure Modes & Recovery

- **Client spreadsheet has formulas the agent can't fully parse:** Document the cell + formula, flag for human review, do not assume.

## Output Artifacts

- `research/04_finance_methodology.md`
