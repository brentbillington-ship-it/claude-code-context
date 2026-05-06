# Family Office Tracker — Synthesis Agent

> **Reads all six research deliverables. Produces consolidated v1 feature priority, UI direction, chart mappings, pricing headline, and a draft style guide.**

## When to Invoke

- After all five research sub-agents complete and the manager has validated their outputs

## Prerequisites

- All six deliverables present and validated
- Discovery recap accessible for cross-checking against the actual ask

## Playbook

1. Read all six deliverables (`01_aesthetics_review.md`, `02_data_visualization.md`, `03_feature_matrix.md`, `04_finance_methodology.md`, `06_pricing_positioning.md`, plus `00_brainstorm.md` for grounding).
2. Produce `00_synthesis.md` covering:
   - Top 10 UI patterns to adopt, prioritized
   - Top 10 chart-type-to-use-case mappings for the dashboard
   - Recommended v1 feature set vs. defer-to-v2 list, reasoning grounded in actual ask
   - Identified white space (features in the ask that no competitor does well)
   - Headline pricing recommendation with decision tree condensed to one page
   - Risks and unknowns
3. Produce `05_style_guide_draft.md` covering:
   - Recommended typography (system fonts / web fonts compatible with Tailwind + shadcn/ui)
   - 2-3 candidate color palettes with rationale, light/dark mode variants, WCAG AA contrast minimums (NEW palettes — no Halff colors, no MMR colors)
   - Component density and spacing scale
   - Iconography recommendations
   - Empty-state and loading-state treatment

## Success Criteria

- v1 feature priority list grounded in actual client ask (cross-references discovery recap)
- 2-3 distinct candidate color palettes with WCAG-validated contrast ratios
- Pricing headline synced with `06_pricing_positioning.md` executive section
- All recommendations tied back to source deliverables

## Failure Modes & Recovery

- **Conflicting recommendations across deliverables:** Surface the conflict explicitly, recommend a resolution with reasoning.
- **Missing input deliverable:** Stop, notify manager, do not produce partial synthesis.

## Output Artifacts

- `research/00_synthesis.md`
- `research/05_style_guide_draft.md`
