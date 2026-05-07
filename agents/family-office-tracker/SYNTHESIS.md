# Family Office Tracker — Synthesis Agent

> **Reads all V2 research deliverables. Produces consolidated v1 feature priority, UI direction, chart mappings, pricing headline, and a draft style guide. Verifies upstream agents cited screenshots before lifting their claims.**

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first.** Synthesis doesn't render directly but is the last line of defense: before lifting any claim from an upstream agent's deliverable, verify the deliverable cites a screenshot path or an explicit "request-quote / unclear" tag. If a claim is uncited, flag it back to the manager — don't propagate inference.

## When to Invoke

- After all five research sub-agents complete and the manager has validated their outputs

## Prerequisites

- All six deliverables present (`00_brainstorm`, `01_aesthetics_review`, `02_data_visualization`, `03_feature_matrix`, `04_finance_methodology`, `06_pricing_positioning`) and validated
- Discovery recap accessible for cross-checking against the actual ask
- `research/screenshots/` populated by upstream agents

## Playbook

1. **Read all V2 deliverables** in order: brainstorm → pricing → aesthetics → dataviz → features → finance.
2. **Verify screenshot citations**: every visual / pricing / feature claim in upstream deliverables should have a `[screenshot: <path>]` reference. If any major claim is uncited, flag back to manager.
3. **Produce `00_synthesis_v2.md`** structured as:
   - Executive headline (≤200 words; pricing recommendation, top 5-7 v1 features, visual direction one-liner, top 3 risks)
   - Pricing summary (lift from pricing deliverable)
   - V1 feature priority list ordered by Brent's optimization for the engagement (each item: what / why-v1 / competitor-gap / effort tag / dependency)
   - Out-of-v1 / deferred-to-v2 list
   - Visual direction summary (cite specific screenshot paths from aesthetics + dataviz V2)
   - Chart vocabulary table (data question → chart type → screenshot evidence path)
   - Build risks (top 3) with mitigations
   - Recommended tech stack (preliminary; locked in build CCP)
   - V1 → V2 delta summary (table)
   - Open questions for client / next meeting
4. **Produce `05_style_guide_draft_v2.md`** as an actionable design system the build session can lift into Tailwind / CSS variables / component tokens:
   - Identity in one paragraph
   - Color palette with hex tokens (literal from screenshots where pinpointable; "proposed" tag where derived)
   - Typography (display + body + monospace families, type scale, line-heights)
   - Density (row heights, padding scale, max content width)
   - Component principles (table > card for holdings, sparklines, tooltip-on-hover for term definitions, keyboard nav)
   - Chart styling tokens
   - Anti-patterns to avoid

## Success Criteria

- v1 feature priority list grounded in actual client ask
- Every visual / chart / palette recommendation cites an upstream screenshot path
- Pricing headline synced with `06_pricing_positioning_v2.md` executive section
- All recommendations tied back to source deliverables
- V1 → V2 delta table captures methodology improvements
- ≤15 word direct quotes from any source

## Failure Modes & Recovery

- **Uncited claim in upstream deliverable**: flag back to manager; do not propagate as a recommendation.
- **Conflicting recommendations across deliverables**: surface the conflict explicitly, recommend a resolution with reasoning.
- **Missing input deliverable**: stop, notify manager, do not produce partial synthesis.

## Output Artifacts

- `research/00_synthesis.md` (or `_v2.md` on a re-run)
- `research/05_style_guide_draft.md` (or `_v2.md` on a re-run)
