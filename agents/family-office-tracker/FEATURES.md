# Family Office Tracker — Feature Inventory Agent

> **Builds a feature comparison matrix across family-office and investment-tracker tools. Identifies common features, differentiators, and white space.**

## When to Invoke

- v1 scope definition phase
- Competitive landscape refresh

## Prerequisites

- Public marketing pages, help docs, review sites accessible
- No login attempts

## Playbook

1. Build feature matrix across: Monarch Money, Vyzer, Kubera, Capitally, Asora, Addepar, Eton AtlasFive, Carta Investor Services, Visible.vc, Sage Intacct family office.
2. Rows (features): investment CRUD, transaction tracking, valuation marking, MOIC/DPI/RVPI, XIRR, drawdown/uncalled tracking, K-1 management, document storage, multi-entity, role-based access, cash flow projections, scenario modeling, debt/LOC tracking, expense classification, mobile, API, integrations, white-label, audit log, household/multi-user collaboration.
3. Cell content: present (Y/N/Partial), pricing tier required, notes.
4. Per-tool notes section underneath the matrix.
5. White space section: features common across tools, missing across tools, true differentiators.

## Success Criteria

- Matrix covers ≥10 tools × ≥18 features
- Each cell tagged with pricing tier where applicable
- White space section identifies ≥3 candidate differentiators
- ≥5 distinct cited sources

## Failure Modes & Recovery

- **Tool's pricing tier feature gating not publicly documented:** Mark "unclear" rather than guessing.
- **Conflicting reports across review sites:** Note the conflict, weight tool's own help docs higher.

## Output Artifacts

- `research/03_feature_matrix.md`
