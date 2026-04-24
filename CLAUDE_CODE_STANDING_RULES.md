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

## Sandbox / Network — github.io Block Fix

### Symptom

Playwright navigating a live `*.github.io` URL fails with `403 host_not_allowed` or `ERR_INVALID_AUTH_CREDENTIALS`. Claude Code's sandbox proxy blocks the request before it reaches GitHub Pages. This also affects `script.google.com`, `sheets.googleapis.com`, and any other external host not in the allowlist.

Canvassing-Map CLAUDE.md Rule 1 documents this symptom — the settings fix below is the remedy.

### Fix

Create `.claude/settings.local.json` in the project root:

```json
{
  "sandbox": {
    "network": {
      "allowedDomains": [
        "*.github.io",
        "github.com",
        "api.github.com",
        "raw.githubusercontent.com",
        "codeload.github.com",
        "*.googleapis.com",
        "script.google.com",
        "sheets.googleapis.com",
        "maps.dcad.org"
      ],
      "allowLocalBinding": true
    }
  }
}
```

This baseline list covers all active projects. **Add project-specific domains per-repo** (e.g., a third-party tile server or data API) — don't put one-off domains in the global list.

### Gitignore Rule

Add `.claude/settings.local.json` to the repo's `.gitignore`. This file is machine-local and must never be committed.

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

### Version Numbering Convention

Applies to any repo using `APP_VERSION` (Canvassing-Map, Signs Map, other web apps). Three tiers — pick the smallest that honestly fits:

- **Whole number bump** (`7.0` → `8.0`): Very significant app changes and additions — major overhaul, new subsystem, architectural rewrite, or a release worth announcing.
- **Decimal bump** (`7.0` → `7.1`): Significant bug fixes or new features. Release worth end-to-end testing.
- **Letter suffix** (`7.0` → `7.0a` → `7.0b`): Single-change hotfixes and very minor adjustments (one-line edits, copy tweaks, emoji strips, style nudges). Lowercase, sequential.

Every bump — letter, decimal, or whole — requires updating **all** `?v=` cache busters in `index.html` to match, or browsers serve stale assets.

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

## Debugging Discipline — Non-Negotiable

These rules exist because a single map-accuracy debugging session burned
five shipped versions without fixing the bug, lost the user's trust, and
made the tracker worse. Re-read before debugging any visual or
user-visible bug.

### D1. User observation outranks any tool query

If the user says "this looks wrong" and a tool (reverse-geocoder,
metadata lookup, API response) says "it's right," the user is right.
Load the exact view they're looking at and compare. Do not reply
"the data says it's correct."

### D2. Visual features require visual verification before "shipped"

A fix touching anything the user can see on screen — markers, charts,
layout, colors, tooltips, map placement — is not "shipped" until:
  (a) The output is rendered in the live preview at the specific
      scenario that was broken
  (b) Compared against a ground-truth source (Google Maps for
      addresses, the user's screenshot for UI, etc.)
  (c) Evidence of (a) + (b) is recorded (screenshot, measurement,
      or the comparison itself)

Code-path tests ("the function returns the expected value") do not
count. They verify the function, not the user-visible outcome.

### D3. Observation is step 1. Theory is step 2

If caught writing a 2-paragraph theory about the cause of a visual
bug before doing a 30-second visual check, stop. Render it, look at
it, screenshot it, then theorize. Theory without observation is
gaslighting the user with plausible-sounding guesses.

### D4. One fix per commit when debugging a specific symptom

While chasing a specific bug report, releases are narrow and each
verified before the next. Bundling the fix with unrelated work makes
it impossible for anyone — including the model — to say whether the
fix worked. The user cannot bisect a release that changes 12 things.

### D5. Two user pushbacks on the same symptom = read-only mode

After the second "still wrong" from the user on the same symptom,
no more commits until the root cause is identified and a single-commit
fix is proposed with evidence. Shipping more "maybe-fixes" dilutes
trust and compounds drift.

### D6. Build the regression set, keep running it

When phase-0 diagnosis produces test cases, those cases are the
regression set. Re-run after every change that could affect them.
Any case that passed a code-path test but failed a visual test means
the visual test is the one that counts going forward.

### D7. For mapping specifically

Parcel centroid ≠ rooftop. Legal parcel polygons often include
driveways, setbacks, and deep back yards; the geometric center often
lands on lawn, not on the house. If a jurisdiction publishes
aerial-aligned parcel data (Coppell does, via the sign-map repo's
`parcels.js`), that is the canonical source and deviating from it
requires explicit justification *and* visual verification.

For multi-match SITEADDRESS lookups (condos, duplexes, common-area
HOA parcels sharing a street address), filter owner names —
"HOMEOWNERS", "ASSOCIATION", "HOA", "COMMON AREA" parcels are
generally not where the residents live.

### D8. Ground-truth scraping via Playwright — no paid APIs

When a user wants address-to-coord ground truth and there is no paid
geocoder key, use Playwright (msedge channel per the playwright-via-Edge
rule above) to drive Google Maps or the DCAD property viewer. Extract
the coord from the URL after the site resolves the address. This is
the canonical pattern for the "compare stored coord vs. real location"
loop on this account.

---

## Active Projects

| Project | Repo | Notes |
|---------|------|-------|
| Canvassing App | `brentbillington-ship-it/Canvassing-Map` | GitHub Pages + Google Sheets + Leaflet.js, pw: choochoo |
| Municipal Markets | `brentbillington-ship-it/Municipal-Markets` | Halff internal only — zero Billington Works branding |
| Signs Map | — | Apps Script, pw: choochoo |

---

*Last updated: April 2026*
