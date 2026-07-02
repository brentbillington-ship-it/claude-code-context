# Family Office Tracker — Data Visualization Agent

> **Synthesizes data viz best practices from Tufte/Munzner/Cairo/Few alongside screenshot-verified vendor chart patterns, then maps specific chart types to specific tracker dashboard needs.**

> **See also:** [`playbook/agents/data-viz-reviewer.md`](../../playbook/agents/data-viz-reviewer.md) — generic chart/dashboard reviewer for Halff/client deliverables. Different scope: this file is engagement-specific (vendor competitive review with R1 rendered screenshots); the template is generic chart correctness review.

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first. Every chart claim in the deliverable MUST be backed by a screenshot the agent actually viewed — render the page, save the PNG, Read the PNG file path so the chart enters visual context. Only after viewing the rendered chart does the agent describe it.**

V1 failure mode this avoids: V1 asserted chart designs for Monarch / Vyzer / Kubera with zero rendered screenshots — pure inference from marketing copy. V2 grounds every chart claim in pixels.

## When to Invoke

- v1 dashboard design phase
- Refresh when adding new visualization-heavy features

## Prerequisites

- Access to public summaries of viz textbooks (MIT OCW, condensed entries) — Tufte/Munzner/Cairo/Few
- Pre-flight Playwright smoke test passed (per RESEARCH_METHODOLOGY_V2.md R3)
- `research/screenshots/dataviz/` directory exists
- No copyrighted text reproduced (≤15 word direct quotes)

## Playbook

1. **Verify Playwright works** by rendering Monarch's homepage or features-marketing page first. Save screenshot. Read it. If render fails, halt and report.
2. **Render and screenshot vendor charts** (full-page, viewport 1440x900, networkidle, 30s timeout, msedge channel). Coverage targets:
   - Net worth over time (Monarch, Range, Finary)
   - Portfolio performance with benchmark (Monarch, Koyfin)
   - Asset allocation donut/sunburst (Vyzer, Finary, Asora)
   - Cashflow waterfall / contribution-distribution timeline (Vyzer, Carta marketing)
   - Drawdown / capital-call timeline (Carta, Asora marketing, Vyzer)
   - Scenario projection / fan chart (Wealthfront, Personal Capital marketing)
   - Liquidity / lifecycle visualization (family-office platform marketing)
   - Factor-exposure diverging bar (Venn)
3. **Read each screenshot** before writing observations about the chart.
4. **Summarize textbook principles** in own words (≤15 word direct quotes); cite Tufte (data-ink ratio, small multiples, sparklines), Munzner (encodings, channel ranking), Cairo (truthful design, perceptual fidelity), Few (dashboard design).
5. **Reddit threads** (if cited): render the actual thread URL via Playwright (JS-heavy; networkidle), save screenshot, cite both URL and screenshot. Subreddits: r/dataisbeautiful, r/personalfinance, r/financialindependence, r/fatfire.
6. **Map chart types to tracker needs**: each row pairs a data question to a chart type to screenshot evidence path.
7. **Anti-patterns section**: pie >5 segments, stacked area for time-series, 3D, gauges, dual-axis line charts, rainbow-as-sequential — each grounded in either a screenshot showing the anti-pattern OR a principle citation.
8. **Color/encoding direction**: concrete recommendation for sequential / categorical / diverging palettes given finance domain (gains/losses → diverging).

## Success Criteria

- Chart-type-to-use-case mapping for ≥7 tracker dashboard needs
- Every chart claim paired with screenshot path or YouTube walkthrough URL
- Failure modes documented per chart type
- ≥5 distinct cited sources
- ≤15 word direct quotes from any author
- No invented colors/styles — if not visible in screenshot, say so

## Failure Modes & Recovery

- **Vendor sub-page 404s** (Vyzer `/features` etc.): use root, `/platform`, blog posts that showcase dashboards
- **Cloudflare-walled vendors** (Carta `/lp/`, Sage): document the block; use alternate sources for the same chart family
- **Anti-bot CAPTCHAs** (Seeking Alpha): document, do not bypass

## Output Artifacts

- `research/02_data_visualization.md` (or `_v2.md` on a re-run)
- `research/sources/reddit_threads.md`
- `research/sources/books_referenced.md`
- `research/screenshots/dataviz/*.png`
