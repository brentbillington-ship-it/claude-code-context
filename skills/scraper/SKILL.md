---
name: scraper
description: Build Python web scrapers with Playwright, rate limiting, and error recovery. Use for municipal data collection, vendor page monitoring, and any multi-page extraction job. Not for one-off page reads (use WebFetch) or visual QA (use browser-qa).
allowed-tools: Bash, Read, Write
---

# Scraper

Converted to official Agent Skills format 2026-07-02 (was a loose .md with unparseable frontmatter). For the full boilerplate (robots.txt respect, retry/backoff, schema-validated output), see `playbook/templates/skills/scraping-pipeline-boilerplate/SKILL.md` and the `playbook/agents/web-scraper.md` agent; this skill is the inline short form.

## Steps

1. MUST use Playwright for JS-heavy sites. Browser channel per standing rules § Browser channel (environment-dependent).
2. Use requests + BeautifulSoup for static pages only.
3. MUST use `wait_until="networkidle"` for `page.goto()`.
4. MUST set explicit timeouts (30s default).
5. Include rate limiting and error recovery.
6. For large scraping tasks (11+ cities), use the subagent pattern to protect main-session context (standing rules § Subagent Pattern).
7. Output to CSV with headers matching the target schema.
8. Test on 3 pages before the full run.
9. Screenshot on any failure for debugging.
