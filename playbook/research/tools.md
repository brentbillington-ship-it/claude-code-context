# Tool Catalog Scout — Report

*Compiled 2026-04-22 for Brent. Baseline stack: Superpowers v5.0.7, Sequential Thinking, Context7, pdf-mcp, google_workspace_mcp, github-mcp-server, Chrome MCP, Playwright CLI + Playwright MCP, CLASP.*

## Ranking method
Scored each candidate on four axes: (1) practitioner adoption — real GitHub stars + install counts on claudemarketplaces / mcp.so leaderboards, discounting blog-boosted newcomers; (2) stability — ≥6 months of commit history, <20% open-issue ratio, known maintainer; (3) token cost — measured in tool-definition tokens loaded upfront (Playwright MCP baseline ~13.7k / 6.8% context); (4) Brent-fit — direct overlap with AutoLISP/civil, campaign/scraping, Apps Script, Python, freelance delivery. Anything duplicating an installed tool is marked SKIP regardless of stars.

## MCP servers worth adding (net-new)

| Server | Purpose | Maintainer | Token cost | Brent-fit | Priority |
|---|---|---|---|---|---|
| **Serena** (oraios/serena) | Symbol-level semantic code nav via LSPs across 30+ languages; in-place edits without loading whole files | oraios, 18-mo history, weekly commits | Medium (~8k, lazy-loaded) | High — massive for multi-file Python/Playwright refactors, works on LISP-adjacent files too | **Essential** |
| **Exa** (exa-labs/exa-mcp-server) | AI-native web search; returns clean content, not SERP noise | Exa Labs, funded, 12-mo maintained | Low (~3k, 4 tools) | High — campaign research & scraping recon without burning Firecrawl credits | **Strong add** |
| **Firecrawl** (firecrawl/firecrawl-mcp-server) | Structured scraping + crawl + extract schemas; 500 free pages/mo | Firecrawl (official), very active | Medium (~6k) | High — scraping backbone; pairs with Playwright for JS-heavy sites | **Strong add** |
| **autocad-mcp** (puran-water/autocad-mcp) | Freehand AutoLISP execution against AutoCAD LT, P&ID symbols, ezdxf backend, undo/redo | puran-water, niche but active since 2025 | Low (~4k, 8 tools) | Very high — the only credible civil/CAD bridge; direct LISP dispatch | **Essential** (if CAD work recurs) |
| **Sentry** (getsentry/sentry-mcp) | Pull error traces into context, tie to commits | Sentry official | Low | Medium — only if freelance clients use Sentry | Nice-to-have |
| **Chrome DevTools MCP** (google) | Performance audits, Web Vitals, CPU/network emulation, attach to live Chrome | Google Chrome team | High (~18k, 26 tools, 9% context) | Medium — overlaps Chrome MCP + Playwright already; only add if auditing client sites | Nice-to-have |
| **Notion MCP** (makenotion/notion-mcp) | Read/write team KB, project notes | Notion official | Medium (~7k) | Medium — only if Brent uses Notion; otherwise skip (Google Docs covers it) | Skip unless already on Notion |
| **mcp-ripgrep** (mcollina/mcp-ripgrep) | Exposes `rg` to agent; faster than Grep tool on huge trees | Matteo Collina (Node core), stable | Very low (~1.5k) | Low — Claude's built-in Grep tool already wraps rg | Skip |

## MCP servers that duplicate what Brent has — SKIP

- **Official Filesystem MCP** — duplicates built-in Read/Write/Edit/Glob.
- **Puppeteer MCP / BrowserBase / Browser MCP** — Playwright MCP + Chrome MCP + Playwright CLI already cover this three ways over.
- **Any Google Drive/Sheets/Docs MCP** (including the MCP Toolbox Drive server) — google_workspace_mcp (taylorwilsdon) is strictly better.
- **Any GitHub MCP** (smithery, composio, etc.) — github-mcp-server (official) is the canonical one.
- **Library docs servers (DeepWiki, ref-tools)** — Context7 already does this.
- **PDF MCPs (pdf-reader, pdfplumber-mcp)** — pdf-mcp is installed.
- **"Thinking" clones (tree-of-thought, beta-thinking)** — Sequential Thinking covers this.

## Plugins (CC marketplace)

Ranked by real adoption (claudemarketplaces.com install counts as of April 2026):

1. **wshobson/agents** — 184 specialized agents + 98 commands + 16 workflow orchestrators split across 78 focused plugins. Cherry-pick, don't install whole. Maintainer: Will Shobson, very active. **Strong add — pick 3-5 plugins, not the whole bundle.**
2. **wshobson/commands** (claude-code-essentials, security-hardening, infrastructure-devops) — production slash commands. **Strong add.**
3. **Claude-Mem** (thedotmack) — cross-session memory via SQLite + vector; complements Superpowers' memory model. **Nice-to-have** — test first, some users report context bloat.
4. **Local-Review** — parallel multi-agent diff review on local branches. Pairs well with freelance delivery. **Strong add.**
5. **Pensyve** — universal memory runtime with lifecycle hooks; 6 commands + 6 hooks. Overlaps Claude-Mem; pick one. **Nice-to-have.**
6. **harperreed/project-workflow-system** — task + review + deploy command set. **Nice-to-have** (overlaps with Superpowers Brainstorm).
7. **connect-apps** (Composio) — 500+ SaaS integrations behind one OAuth. **Skip** unless Brent needs CRM/Stripe/Intercom; token cost is high.

## Slash commands worth adopting

1. `/ship` or `/push` — stage + commit + push with auto-message. Source: wshobson/commands/git-ops.
2. `/code-review` — local parallel review before PR. Source: wshobson/commands/security-hardening.
3. `/ultrareview` — new in Claude 2.1.108, multi-pass deep review. Built-in.
4. `/team-onboarding` — new in 2.1.111, bootstraps CLAUDE.md. Built-in.
5. `/scrape <url>` — one-shot Firecrawl+summarize. Write custom under `~/.claude/commands/scrape.md`.
6. `/lisp <task>` — wrapper that routes to autocad-mcp with Brent's P&ID conventions. Write custom.
7. `/gas-deploy` — CLASP push + deploy + URL grab. Source: adapt from harperreed/project-workflow-system.
8. `/estimate` — freelance scoping template. Write custom, reference Superpowers Brainstorm.

## Hooks worth adopting

| Event | Purpose | Copy-worthy source |
|---|---|---|
| **SessionStart** | Inject current git branch + recent commits + TODO state into context | disler/claude-code-hooks-mastery → `session_start/git_context.sh` |
| **PostToolUse (Write\|Edit\|MultiEdit)** | Auto-format: `prettier`/`black`/`ruff` on changed file | disler mastery repo + blakecrosley.com/blog/claude-code-hooks-tutorial |
| **PreToolUse (Bash)** | Block `rm -rf`, `git push --force`, secret leaks | datacamp.com tutorial, pattern-based allow/deny JSON |
| **PostToolUse (Bash)** | Log every bash command to `.claude/audit.jsonl` for freelance billing | ksred.com guide |
| **Stop** | Run project linter + test gate before declaring done | smartscope.blog pattern |
| **UserPromptSubmit** | Strip/redact API keys before they hit the model | techsy.io production examples |
| **SessionEnd** | Append summary to memory file (works with Superpowers) | disler mastery repo |

Keep total hook set under 10 and each hook <200ms, per current CC docs.

## Marketplaces to subscribe to

- **claude-plugins-official** (Anthropic) — auto-available, 101 plugins.
- **wshobson/agents** — subscribe then enable individual plugins.
- **ccplugins/awesome-claude-code-plugins** — curated, well-filtered.
- **hesreallyhim/awesome-claude-code** — broader list; good for discovery.
- **ComposioHQ/awesome-claude-plugins** — heavy on Composio's own; skim, don't subscribe.
- **mcp.so / mcpservers.org / glama.ai** — for MCP server discovery, not plugin subscription.

## Token-budget math

Current baseline (installed MCP tool definitions, approximate):
- Sequential Thinking ~1k · Context7 ~2k · pdf-mcp ~2k · google_workspace ~6k · github-mcp ~8k · Chrome MCP ~5k · Playwright MCP ~14k = **~38k tokens pre-conversation**.

Adding top-5 picks (Serena + Exa + Firecrawl + autocad-mcp + one wshobson plugin bundle):
- +8k + 3k + 6k + 4k + ~3k (plugin commands are lightweight) = **+24k**.
- **New total: ~62k tokens upfront**, roughly 31% of a 200k context window, 6% of the 1M window Brent runs.

Mitigation: enable MCP servers per-project in `.claude/settings.json` rather than user-global. Keep autocad-mcp off for non-CAD sessions. This is the single biggest lever — one project-scoped config can cut per-session overhead by 15-20k.

## Promising repos for deep-dive

- **github.com/oraios/serena** — installation + language-server setup patterns.
- **github.com/puran-water/autocad-mcp** — civil/P&ID agent skill template; companion `autocad-drafting` skill.
- **github.com/disler/claude-code-hooks-mastery** — 30+ hook patterns, security + logging + context injection.
- **github.com/wshobson/agents** — plugin packaging conventions, CLAUDE.md boilerplate.
- **github.com/wshobson/commands** — production slash command authoring style.
- **github.com/hesreallyhim/awesome-claude-code** — index for weekly discovery.
- **github.com/firecrawl/firecrawl-mcp-server** — scraping skill patterns; see `/examples`.
- **github.com/jbenshetler/mcp-ragex** — alt to Serena if Python-only and want regex+semantic combined.
- **github.com/ccplugins/awesome-claude-code-plugins** — filtered list, better signal than raw awesome lists.

---
*Top-3 actions: install Serena today; install autocad-mcp next CAD session; pick 3 wshobson plugins (essentials + security-hardening + git-ops) and prune.*
