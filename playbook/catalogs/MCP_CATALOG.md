# MCP Catalog — Recommended Servers for Brent's Stack

Ranked by fit for Brent's work (civil/Halff, Billington Works client delivery, campaign tooling, scraping, Apps Script). Token costs are approximate upfront tool-definition sizes.

Source basis: `playbook/research/tools.md` + `playbook/synthesis/RECOMMENDATIONS.md`.

---

## Already installed (keep — don't re-recommend)

| Server | Purpose | Notes |
|---|---|---|
| Superpowers v5.0.7 | Brainstorm + Simplify skills | Mandatory per standing rules |
| Sequential Thinking | Structured reasoning | Use for 3+ interdependent parts |
| Context7 | Library/API docs | Replaces ad-hoc doc lookups |
| pdf-mcp | Large PDF extraction | Two-tier PDF strategy tier 2 |
| google_workspace_mcp (taylorwilsdon) | Sheets / Drive / Docs | Service-account auth |
| github-mcp-server (official) | Repo management | Canonical GitHub MCP |
| Chrome MCP | Browser fallback | Keep as fallback only |
| Playwright MCP + Playwright CLI | Browser automation | CLI for heavy, MCP for interactive |

Approx. baseline cost: **~38k upfront tokens** when all enabled.

---

## Net-new additions — Essential

### Serena (`oraios/serena`) — **P1 Essential**
- **Purpose:** Symbol-level semantic code navigation across 30+ languages via LSPs. In-place edits without loading whole files.
- **Why for Brent:** Biggest productivity jump for Python/Playwright refactors, scraping pipelines, any multi-file cleanup.
- **Token cost:** ~8k, lazy-loaded.
- **Install:** `uvx --from git+https://github.com/oraios/serena serena-mcp-server` (verify install command against current README before running).
- **Scope:** Enable per-project in `.claude/settings.json`, not user-global — keeps idle projects light.
- **Risk:** Low. Active maintainer, 18-month history.
- **License:** MIT (verify on their repo).

### autocad-mcp (`puran-water/autocad-mcp`) — **P1 Essential (for Halff work)**
- **Purpose:** Freehand AutoLISP dispatch to AutoCAD LT / Civil 3D. Undo/redo support. P&ID symbol library. ezdxf backend.
- **Why for Brent:** Only credible civil/CAD bridge in the ecosystem. Unique fit for Halff work.
- **Token cost:** ~4k (8 tools).
- **Install:** Follow their README; Windows-only (AutoCAD LT is Windows).
- **Scope:** Enable only in civil-eng projects; keep OFF for non-CAD sessions.
- **Risk:** Medium — niche maintainer, smaller user base. Verify license before writing client deliverables that depend on it. Pair with the `civil-eng-qto-helper` skill.
- **License:** Unknown — confirm before committing.

---

## Net-new additions — Strong add

### Exa (`exa-labs/exa-mcp-server`)
- **Purpose:** AI-native web search; returns clean content, not SERP noise.
- **Why for Brent:** Campaign research and scraping recon without burning Firecrawl credits.
- **Token cost:** ~3k (4 tools).
- **Risk:** Low. Funded company, active.

### Firecrawl (`firecrawl/firecrawl-mcp-server`)
- **Purpose:** Structured scraping, crawl, extract schemas. 500 free pages/month.
- **Why for Brent:** Scraping backbone for JS-heavy sites where Playwright alone is overkill.
- **Token cost:** ~6k.
- **Risk:** Low. Official server, very active.

---

## Net-new additions — Nice-to-have (install per-project)

### Sentry (`getsentry/sentry-mcp`)
- Only if a client uses Sentry. ~3k tokens.

### Chrome DevTools MCP (Google)
- Performance audits + Web Vitals. ~18k tokens — expensive. Only for client-site audits.

### Notion MCP (`makenotion/notion-mcp`)
- Only if Brent moves team KB to Notion. Otherwise google_workspace_mcp covers it.

---

## SKIP list (duplicates existing tools)

- **Official Filesystem MCP** — duplicates built-in Read/Write/Edit/Glob.
- **Puppeteer MCP / BrowserBase / Browser MCP** — Playwright handles this.
- **Any Google Drive/Sheets/Docs MCP** — google_workspace_mcp is better.
- **Any non-official GitHub MCP** — github-mcp-server is the canonical one.
- **DeepWiki, ref-tools** — Context7 already covers library docs.
- **pdfplumber-mcp, pdf-reader** — pdf-mcp is installed.
- **Tree-of-thought, beta-thinking clones** — Sequential Thinking covers this.

---

## Token budget math (with recommended additions)

| Scenario | Upfront tokens | % of 1M window |
|---|---|---|
| Baseline (installed now) | ~38k | 3.8% |
| + Serena + Exa + Firecrawl (P0 research/dev) | ~55k | 5.5% |
| + autocad-mcp (civil-eng project only) | ~59k | 5.9% |
| All above + Sentry + Chrome DevTools (audit day) | ~80k | 8.0% |

**Rule of thumb:** scope per-project via `.claude/settings.json`. Never load autocad-mcp on a web-app repo.

---

## Operational notes

- Audit `/mcp` monthly. Disable any server you haven't used in 30 days.
- Hard cap: 15 MCP tools visible at once (per ANTI_PATTERNS.md A2).
- Per-project settings always beat user-global for token hygiene.
- Pin server versions where the installer supports it.
- Don't install a new MCP "to try it" in the middle of a paying-client session.

---

## Installation priority (suggested order)

1. Serena (today, in one project, verify workflow)
2. (Optional) Exa + Firecrawl when next scraping/research session starts
3. autocad-mcp the next time a CAD QTO lands on the desk
4. Everything else: only when a concrete project demands it
