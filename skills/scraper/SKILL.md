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
3. Default `wait_until="networkidle"` for `page.goto()` — EXCEPT legacy ASP.NET/Telerik portals, which never go network-quiet: use `domcontentloaded` + explicit element wait (see fingerprints below; on one portal this cut a backfill from ~80h to ~45min).
4. MUST set explicit timeouts (30s default).
5. Include rate limiting and error recovery.
6. For large scraping tasks (11+ cities), use the subagent pattern to protect main-session context (standing rules § Subagent Pattern).
7. Output to CSV with headers matching the target schema.
8. Test on 3 pages before the full run.
9. Screenshot on any failure for debugging.
10. Walk ALL result pages and prove it — a listing that silently serves page 1 to every request zeroes the whole target (e.g. a Municode listing that ignores anything past `&p=1` looks empty until pagination is added). Completeness check before calling a target done: date coverage, volume sanity, one real-record spot check.

## Public agenda/records platforms — fingerprint before building

These are the common government agenda/records systems and their quirks (public portals; behaviors are objective, not source-specific). Scrape the embedded platform, not the site's shell page, and search "<jurisdiction> council meetings" first — the official page's links reveal the real source (sometimes a Laserfiche archive rather than the obvious portal).

| Platform | Fingerprint | The gotcha |
|---|---|---|
| Legistar | `<host>.legistar.com` | Public JSON API at `webapi.legistar.com/v1/<client>/` — use it FIRST, don't scrape the Telerik grid. Verify `%PDF-` magic bytes; error pages get served as PDFs. Confirm the body via `/bodies`. |
| CivicClerk | `<host>.portal.civicclerk.com` | React MUI SPA — the component tree does not map to HTML nesting, never `el.closest("div,li")`. Download direct via `GetMeetingFileStream(fileId)`, not the SPA viewer. |
| Granicus (classic) | `<host>.granicus.com` | RSS at `/ViewPublisherRSS.php`. |
| Granicus (modern) | consolidated-packet variant | Per-item PDFs only, no consolidated packet. |
| Granicus govAccess | WAF variant | Akamai WAF blocks requests AND headless Chromium — Playwright Firefox + stealth only. |
| NovusAgenda | `<host>.novusagenda.com/agendapublic` | Legacy ASP.NET: `networkidle` is a TRAP (never fires) — `domcontentloaded`. PDFs via `DisplayAgendaPDF.ashx?MeetingID=`. |
| PrimeGov | `<host>.primegov.com` | DOM is NOT uniform across deployments. Associate attachments to items by DOM structure, never a page-wide pool (the classic mis-attribution root cause). Portal-migration sites need a data-derived cutover floor, not a hardcoded year. |
| Municode | `meetings.municode.com/PublishPage?cid=` | Paginated listing; fetching only `&p=1` looks like an empty target. |
| OnBase | `agenda.<host>.gov/OnBaseAgendaOnline` | Downloads time out headless. NOTE: OnBase is also a separate county-clerk records API — same name, different system. |
| CivicPlus | `<host>.civicplus.com/AgendaCenter` | Hardest platform: SPA renders empty even in Playwright; some deployments 403 all automation — flag for manual download. |
| DestinyHosted | `destinyhosted.com` | Server-rendered, plain requests usually fine; iterate month-by-month; some listings still need Playwright. |
