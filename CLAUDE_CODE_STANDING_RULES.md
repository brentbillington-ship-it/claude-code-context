# Claude Code — Standing Rules & Context
## Brent Billington | Billington Works / Halff Associates

---

## Who I Am

Civil PE at Halff Associates (DFW). Building a freelance AI dev business called **Billington Works**.
Working email: bbillington@halff.com

---

## Prime Directive — Non-Negotiable

**Never push to GitHub, execute irreversible commands, or take any destructive action without me explicitly saying "go."**

Before any work session:
1. Use the **Superpowers Brainstorm skill** to analyze the codebase and produce a structured plan
2. Present all changes as a numbered list
3. Wait for **"go"** before writing a single line of code

Violations are a trust issue. When in doubt, stop and ask.

---

## Context Management — Follow These Thresholds

- **50% context used** → run `/compact` proactively. Do not wait for auto-compact.
- **70%** → precision drops. Flag it and ask if I want to compact or start fresh.
- **85%** → hallucination risk increases. Stop and compact immediately.
- **90%+** → responses go erratic. Do not proceed without compacting first.

When compacting, always preserve:
- All file paths modified this session
- Current test status (passing/failing)
- The specific error messages being debugged
- Which approach was chosen and why

---

## Plugins & Tools

### Superpowers (v5.0.7)
- MUST invoke Brainstorm before touching any code — no exceptions, even for small changes
- Use `/simplify` after completing a feature as a post-edit quality check

### Sequential Thinking MCP
- Use for any task with more than 3 interdependent parts
- Forces structured reasoning with revision before coding begins
- Do not skip for scraper architecture or multi-city data pipeline work

### Context7 MCP
- Use for documentation lookups and library reference
- Invoke when checking API behavior or library specifics — never guess

### Playwright
- MUST use Playwright for all browser automation — Selenium is fully banned
- MUST use `wait_until="networkidle"` for `page.goto()` — never "load"
- MUST set timeouts explicitly (30s default)
- Always screenshot on failure for debugging
- Use `playwright.sync_api` (sync API)
- Headless mode tied to GUI toggle where applicable
- `playwright install chromium` — do not use Edge

### Playwright CLI vs Playwright MCP
- Use **Playwright CLI** (`@playwright/cli`) for heavy scraping sessions — 75% fewer tokens than MCP
- Use **Playwright MCP** for quick browser checks and interactive debugging
- Install CLI: `npm install -g @playwright/cli@latest`

### pdf-mcp
Two-tier PDF strategy — always follow this:
- **Tier 1:** Claude Code native Read tool for PDFs under 20 pages
- **Tier 2:** pdf-mcp incremental search/paginate for anything larger
- Never dump an entire large PDF into context — use pdf-mcp search to target relevant sections

### CLASP (Google Apps Script deployment)
- MUST use CLASP for all Apps Script changes — never manually paste into the browser editor
- CLASP pushes code directly from the repo to Google without generating a new deployment URL
- Use a stable versioned deployment so the URL in `config.js` never changes
- Workflow: edit `apps_script.js` locally → `clasp push` → done
- Install: `npm install -g @google/clasp`

### google_workspace_mcp (taylorwilsdon)
- Replaces Apps Script intermediaries for reading/writing Sheet data in-session
- Covers Sheets, Drive, Docs — 12 Google services in one server
- Use for data access; use CLASP for code deployment — they are complementary, not competing
- Auth: service account (recommended)
- Install: `uvx workspace-mcp --tool-tier complete`

---

## MCP Servers — Installed & Approved

| Server | Purpose | Priority |
|--------|---------|----------|
| Superpowers v5.0.7 | Brainstorm, Simplify skills | Essential |
| Sequential Thinking | Structured reasoning before coding | Essential |
| pdf-mcp | Large PDF extraction without context overflow | Essential |
| google_workspace_mcp (taylorwilsdon) | Sheets, Drive, Docs data access | Essential |
| github-mcp-server (official) | Repo management, PRs, CI — replaces Chrome MCP hack | Essential |
| Context7 | Library/API documentation | Essential |
| Chrome MCP | JavaScript tool for browser actions | Fallback only |

**MCP token budget warning:** Do not exceed ~20k tokens of active MCP servers. Enable only what the session needs — adding everything at once degrades performance significantly.

---

## Custom Skills

Skill files live in `skills/` in this repo. Reference them at session start or copy into `.claude/skills/` in a project.

---

## Subagent Pattern — Large Scraping Tasks

For overnight runs or multi-city scraping (Municipal Markets, etc.), fork context via subagents:
- Run exploratory scraping in a subagent to protect main session context from HTML dumps
- Main session handles orchestration, config, and output writing only
- Each city scraper runs as its own subagent where possible

---

## Notifications — When Complete or Blocked

**Desktop (Windows PC):**
```powershell
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Claude Code needs your input — check browser', 'Claude Code')"
```

**Mobile (on phone — use this instead of PowerShell):**
Send a push notification through the Claude app's built-in notification system.

**Always notify:**
- When the brainstorm plan is ready and waiting for "go"
- When blocked and need input
- When the full work order is complete

---

## GitHub

### Preferred — github-mcp-server (official)
Use for all repo operations: browse files, create PRs, check CI, manage issues.
Remote endpoint: `https://api.githubcopilot.com/mcp/`

### Fallback — Chrome MCP workaround
Only if github-mcp-server is unavailable:
- Open a `github.com` tab in Chrome
- Use `javascript_tool` via Chrome MCP
- `fetch()` with `Authorization: token <PAT>` header
- GET file sha first, then PUT with base64-encoded content

**Never commit destructive changes** (force push, delete branch, rewrite history) without explicit approval.

---

## Python Stack

| Tool | Rule |
|------|------|
| Browser automation | MUST use Playwright — Selenium is banned |
| PDF tables | MUST use pdfplumber — never tabula |
| PDF OCR fallback | pytesseract only when no text layer exists |
| PDF scanned pages | Convert to image, use Claude vision via Read tool |
| AI extraction (single) | Claude Haiku |
| AI extraction (batch 50+ PDFs) | Batch API |
| Excel write | openpyxl |
| Excel read | pandas |
| GUI | customtkinter |
| Linting | Ruff (`ruff check . --fix` then `ruff format .`) |
| Terminal | `py` not `python` — `py -m pip` not `pip` |

### Ruff PreToolUse Hook
Add to Claude Code settings — catches Python issues before they compound:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "ruff check --stdin-filename \"$TOOL_INPUT_FILE\" || true"
      }]
    }]
  }
}
```

---

## VS Code Extensions — Installed & Approved

| Extension | Purpose | Priority |
|-----------|---------|----------|
| Claude Code (Anthropic official) | Native Claude Code GUI in VS Code | Essential |
| Ruff | Python linter + formatter, replaces flake8/black | Essential |
| Pylance | Python type checking and IntelliSense | Essential |
| Live Server (Ritwick Dey) | Local dev server with live reload for GitHub Pages/JS work | Strong add |
| CLASP + Apps Script Pack | Local Apps Script editing and deployment | Strong add |
| Data Preview | Preview CSV/JSON/Excel output without leaving editor | Nice-to-have |
| vscode-pdf (tomoki1207) | PDF viewer inside VS Code | Nice-to-have |

---

## Code Delivery Rules

- Only changed files go in the zip — never include unchanged files
- Zip with original filenames, timestamps in Central Time via `touch -t`
- `version.js` and all `?v=` query strings in `index.html` bump on every release
- GUI scripts → `.pyw` | Pipeline modules → `.py`
- Apps Script: equality checks require `String()` coercion on both sides

---

## CLAUDE.md Rules (for project-level files)

- Keep under 200 lines — if removing a line wouldn't cause mistakes, cut it
- Critical rules go in the **first 5 and last 5 lines** — middle content gets less attention
- MUST use positive framing — "MUST use named exports" not "do NOT use default exports"
- Build/run commands belong at the very top
- Code style rules belong in Ruff/ESLint config, not CLAUDE.md
- Use `CLAUDE.local.md` (git-ignored) for personal sandbox URLs and test credentials

---

## Communication Style

- Short prompts, direct answers — no preamble
- Give your best recommendation with a reason — not a list of options to pick from
- Flag problems before they happen
- Never theorize when you can read the actual file
- If something seems wrong or risky, say so before proceeding

---

## Active Projects

| Project | Repo | Notes |
|---------|------|-------|
| Canvassing App | `brentbillington-ship-it/Canvassing-Map` | GitHub Pages + Google Sheets + Leaflet.js, pw: choochoo |
| Municipal Markets | `brentbillington-ship-it/Municipal-Markets` | Halff internal only — zero Billington Works branding |
| Signs Map | — | Apps Script, pw: choochoo |

---

*Last updated: April 2026*
