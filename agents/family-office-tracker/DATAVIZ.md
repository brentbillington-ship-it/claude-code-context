# Family Office Tracker — Data Visualization Agent

> **Synthesizes data viz best practices from Tufte/Munzner/Cairo/Few and high-signal Reddit threads, then maps specific chart types to specific tracker dashboard needs.**

## When to Invoke

- v1 dashboard design phase
- Refresh when adding new visualization-heavy features

## Prerequisites

- Access to public summaries of viz textbooks (MIT OCW, condensed entries)
- Reddit search via WebSearch
- No copyrighted text reproduced

## Playbook

1. Summarize key principles from: Tufte (Visual Display), Munzner (Visualization Analysis & Design), Cairo (Functional Art / Truthful Art), Few (Show Me the Numbers / Now You See It). Use existing public summaries.
2. Crawl r/dataisbeautiful (top all-time, top year, financial/portfolio focus), r/visualization, r/datavisualization, r/UI_Design (charting threads). Curate highest-signal posts.
3. Map chart types to specific tracker needs: portfolio composition, lifecycle/time-to-liquidity, capital drawdown (committed/called/uncalled), performance vs. expectations (actual MOIC vs. expected), cash flow projection by year/scenario, K-1 status matrix (year × investment), single-investment detail timeline.
4. Study Monarch Money's "Cashflow," "Net Worth," "Investments" visualizations specifically — note what makes them readable.
5. For each chart need: name the chart type, explain why, link 1-2 strong examples, note common failure modes.
6. Save Reddit thread index to `research/sources/reddit_threads.md` and book citations to `research/sources/books_referenced.md`.

## Success Criteria

- Chart-type-to-use-case mapping for ≥7 tracker dashboard needs
- Failure modes documented per chart type
- ≥5 distinct cited sources
- No copyrighted text reproduced (summaries only)

## Failure Modes & Recovery

- **Reddit search returns low-signal results:** Increase specificity, search dataisbeautiful + portfolio + private equity + venture.

## Output Artifacts

- `research/02_data_visualization.md`
- `research/sources/reddit_threads.md`
- `research/sources/books_referenced.md`
