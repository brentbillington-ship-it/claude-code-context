# CLAUDE.md — Scraping Pipeline (Municipal Markets–style)

## Build / Run

```
py -m pip install -r requirements.txt
playwright install chromium          # never Edge
py run_all.py --dry-run
py run_all.py --cities all
py run_all.py --cities austin,dallas --out output/2026-04-22.xlsx
```

---

## Prime rules

1. MUST use Playwright CLI for heavy sessions. Playwright MCP for quick checks only.
2. MUST `wait_until="networkidle"` on every `page.goto()`. Never `"load"`.
3. MUST set explicit timeouts (30s default) and screenshot on failure.
4. MUST use `py` not `python`. `py -m pip` not `pip`.
5. MUST run each city's scraper as a subagent so HTML dumps don't pollute main context.

---

## Stack

- Browser: Playwright sync API + chromium
- LLM extraction: Claude Haiku for per-row structured output (batch API for 50+ items)
- Storage: SQLite for dedup / caching; openpyxl for Excel output; `output/` gitignored
- Linting: Ruff (`ruff check --fix && ruff format`)
- Dev loop: Pre-commit hook via `ruff-pretooluse.sh` from CCC playbook

## File layout

```
scrapers/<city>.py        # one per target
extractors/llm_haiku.py   # shared extraction helper
writers/excel.py
config.py                 # endpoints, selectors, rate limits
run_all.py                # orchestrator
tests/                    # pytest; network-mocked
output/                   # gitignored
.claude/settings.json     # enables autocad-mcp off; MCP budget tight
```

## Extraction pattern

- Playwright gets the rendered HTML → extract text chunks
- Claude Haiku converts chunks → structured JSON (one call per row, batched in sets of 50)
- Writer aggregates → Excel with one sheet per city
- Run metadata: timestamp (Central), row counts, error tally, saved to `runs.json`

## What NOT to do

- Don't commit raw HTML, raw API responses, or the output Excel to git
- Don't leave credentials in `config.py`. Use env vars + `.env` (gitignored)
- Don't scrape without respecting `robots.txt` and reasonable rate limits (1 req / 2s default)
- Don't broaden selectors to "just work" — write explicit, brittle selectors and update them when sites change

## Last 5 lines — pre-run

- Dry run passed on 2 cities?
- `.env` present and untracked?
- Rate-limit config sane?
- Output dir writable + cleanable?
- Excel schema matches consumer's expectations?
