---
name: scraping-pipeline-boilerplate
description: Use when setting up a new scraping pipeline (multi-city municipal style, or one-off research scrape). Wires Playwright CLI + Claude Haiku extraction + openpyxl Excel output + subagent-per-city pattern. Do not use for simple single-URL fetches — just use WebFetch for those.
when_to_use: The user mentions scraper, scraping pipeline, multi-city scrape, Playwright job, or wants a new data-extraction script scaffolded.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Scraping Pipeline Boilerplate

Scaffolds a new Python scraping project aligned with CCC standing rules. Follow Playwright CLI for heavy jobs (75% fewer tokens than MCP per standing rules).

## Output layout

```
<project>/
├── CLAUDE.md              # scraping-pipeline.CLAUDE.md template
├── .claude/
│   ├── settings.json      # inherits hook bundle; project-scoped MCP only
│   └── skills/            # project-specific skill overrides
├── scrapers/
│   ├── __init__.py
│   └── <city>.py          # one file per city — runs as own subagent
├── extractors/
│   └── llm_haiku.py       # structured extraction via Claude Haiku
├── output/
│   └── .gitignore         # raw HTML + interim JSON never committed
├── writers/
│   └── excel.py           # openpyxl writer
├── config.py              # endpoints, selectors, rate limits
├── run_all.py             # orchestrator
└── pyproject.toml         # ruff + pytest
```

## Procedure

1. Confirm Python 3.11+ is active. Use `py` per standing rules (not `python`).
2. Install: `py -m pip install playwright openpyxl pandas anthropic`, then `playwright install chromium`.
3. Generate `scrapers/<city>.py` per target city — each scraper is self-contained and callable as a subagent from `run_all.py`.
4. `extractors/llm_haiku.py`: batch prompts to Claude Haiku for structured JSON extraction. Cache responses keyed by input hash.
5. `writers/excel.py`: produce one workbook per run, worksheet per city, timestamped filename in Central Time.
6. `run_all.py` orchestrates via the subagent-per-city pattern: parent handles config + final write; each city gets its own subagent so HTML dumps never pollute the main context.
7. Default hooks: `rm-rf-guard.sh`, `secret-scan-preedit.sh`, `ruff-pretooluse.sh`.

## Non-negotiables

- `page.goto(url, wait_until="networkidle")` — never `"load"`. Exception: legacy ASP.NET/Telerik portals never go network-quiet — use `domcontentloaded` + an explicit element wait (see `skills/scraper/SKILL.md` § Public agenda/records platforms).
- Timeouts explicit, default 30s. Screenshot on failure.
- Selenium is banned.
- Raw HTML and API responses NEVER committed — they go to `output/` which is gitignored.
- Credentials always via env vars, never hardcoded.
- Every tabular/direct importer carries its own poison guard (spend-cap/refusal detection) — orchestrator-level limit detection does not protect importers that bypass it (a silent refusal once dropped years of data for two segments).
- Structured-payment / tabular importers run the QA red flags before promote: one category > ~35% of rows, a window-start year far above the rest, duplicate transaction/record ids > 0, category leakage, un-canonicalized entity names.

## Pairs with

- Playwright CLI (heavy sessions) / Playwright MCP (quick checks)
- `campaign-data-processor` if output feeds Canvassing-Map
- a brand-compliance pass if output feeds a firm-branded deliverable
- `bw-client-deliverable` if scraping is a Billington Works deliverable
