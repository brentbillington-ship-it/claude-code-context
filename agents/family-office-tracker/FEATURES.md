# Family Office Tracker — Feature Inventory Agent

> **Builds a screenshot-cited feature comparison matrix across family-office and investment-tracker tools. Identifies common features, differentiators, and white space (defensibility wedges).**

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first. Every ✓/✗ feature-matrix cell MUST be paired with a screenshot path showing the vendor's claim. Tag cells "Unclear" rather than guessing — V1 inferred from product marketing language and produced false certainty.**

V1 failure mode this avoids: V1 made tier × feature claims based on inferences from marketing copy. V2 verifies each cell against vendor's own pricing/features page (rendered + screenshot) and uses "Unclear" for pages that neither claimed nor denied.

## When to Invoke

- v1 scope definition phase
- Competitive landscape refresh

## Prerequisites

- Pre-flight Playwright smoke test passed (per RESEARCH_METHODOLOGY_V2.md R3)
- `research/screenshots/features/` directory exists
- Pricing agent's `research/screenshots/pricing/` may be reused where pricing pages already show feature lists

## Playbook

1. **Verify Playwright works** by rendering Vyzer's `/individual-investors` page first (Vyzer's pricing/features live there; `/pricing` 404s). Save screenshot. Read it. If render fails, halt and report.
2. **Render and screenshot each vendor's features/pricing page**. May need multiple pages per vendor (`/`, `/platform`, `/features`, `/pricing`). Save to `research/screenshots/features/<vendor>.png` (or `<vendor>_<page>.png` for multi-page coverage).
3. **Vendors (rows)**: Vyzer (Plus / Premium / Elite), Kubera (Essentials, Black), Monarch Money (Core, Plus), Capitally / mycapitally (Sailor, Navigator, Captain — note `mycapitally.com`, NOT `capitally.com`), Asora (Base + add-ons), Masttro (public claims only), Aleta (public claims only), Addepar (public marketing only), Eton AtlasFive (public marketing only), Sage Intacct family-office, Carta investor portal (public marketing only).
4. **Features (columns)** — driven by each engagement's discovery doc. Reference set:
   - Returns: XIRR, MOIC, DPI/RVPI
   - PE workflow: K-1 tracking, capital-call workflow, drawdown/uncalled tracking
   - Document handling: storage tied to investments, doc AI, K-1 box-level extraction
   - Operational: alerts/notifications, debt-facility tracking, scenario projections, Excel/CSV export
   - Architecture: single-tenant data ownership, schema control, multi-entity, custodian integrations, role-based permissions
5. **Cell content**: ✓ (vendor explicitly claims at this tier on a rendered page; screenshot path inline) / ✗ (vendor explicitly denies) / "Unclear" (page neither claimed nor denied) / "n/a — request-quote" (no public claim).
6. **Cross-verify ambiguous claims** (e.g., Vyzer "advanced AI document processing" — does it cover K-1s specifically?) against vendor help center or G2/Capterra. Render the second source. Document any disagreement.
7. **Per-vendor narrative paragraph** under the matrix summarizing feature posture with screenshot citations.
8. **Gap analysis section**: features the engagement needs that NO competitor delivers cleanly — these are the build's defensibility wedges.
9. **Build implication**: for each must-have feature, custom-dev required vs. SaaS shortcut.

## Success Criteria

- Matrix covers ≥10 vendors × ≥15 features
- Every ✓ cell paired with a screenshot path showing where the vendor claims it
- "Unclear" used wherever the rendered page neither claimed nor denied
- ≥3 defensibility wedges identified in gap analysis
- ≥5 distinct cited sources
- Source disagreements (vendor vs. third-party) explicitly documented

## Failure Modes & Recovery

- **Vendor pricing/features page 404s on standard URL**: try root, `/platform`, `/individual-investors`, `/family-office`, etc. The `/pricing` URL is unreliable across vendors.
- **Login wall blocks deep-dive**: cite public marketing only; mark internal screens "Unclear"
- **Cloudflare blocks** (Sage Intacct): document the block; use alternate vendor sources where possible
- **Domain confusion** (Capitally trap): verify domain identity before quoting

## Output Artifacts

- `research/03_feature_matrix.md` (or `_v2.md` on a re-run)
- `research/screenshots/features/*.png`
