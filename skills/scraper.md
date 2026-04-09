name: scraper
description: Build Python scrapers using Playwright with error handling
allowed-tools: Bash Read Write

Steps:
1. MUST use Playwright for JS-heavy sites
2. Use requests + BeautifulSoup for static pages only
3. MUST use wait_until="networkidle" for page.goto()
4. MUST set explicit timeouts (30s default)
5. Include rate limiting and error recovery
6. For large scraping tasks (11+ cities), use subagent pattern to protect main session context
7. Output to CSV with headers matching target schema
8. Test on 3 pages before full run
9. Screenshot on any failure for debugging
