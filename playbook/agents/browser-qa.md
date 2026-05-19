---
name: browser-qa
description: Browser-based visual and functional QA against a live or local URL. Use before any web-app deploy, after a CSS/JS change that could shift layout, or when standing rules say "run visual QA" (Canvassing-Map releases use the project-specific extension at `AGENTS_VISUAL_QA.md`). Tool-agnostic — picks the most efficient browser surface per task per `feedback_browser_tool.md` and the empirical findings in `_audit/C-browser-stack.md` and `_validation/comparison.md`. Mobile/tablet/desktop screenshots, console-error sweep, baseline diff. Always `wait_until="networkidle"` on goto; never `'load'`.
tools: Read, Glob, Grep, Bash, Write, WebFetch
model: sonnet
---

# browser-qa

> **Purpose:** Browser-based visual and functional QA against a live or local URL. Tool-agnostic. Replaces manual click-through for releases.

## When to Invoke
- Before any web-app deploy
- After a CSS or JS change that could shift layout
- When standing rules say "run visual QA" — for Canvassing-Map specifically, the project-specific extension at `AGENTS_VISUAL_QA.md` (CCC root) is the operational playbook; use this generic agent for any other web target
- For BB-Notes / Billington-Works-Site / GH Pages sites that don't have their own QA agent yet

## Tool selection — pick the most efficient surface per task

The original April-2026 playbook locked this to Playwright CLI. **That's stale on two axes** (validated 2026-05-10):

1. **`@playwright/cli` is currently broken on Brent's Windows + Node stack.** Tested across Node 24.15 / 22.22 and CLI 0.1.13 / 0.1.10: daemon crashes on startup at `Pipe.onStreamRead`. Park the session-CLI pattern until upstream fixes the Windows IPC bug. Do NOT recommend `@playwright/cli` as the default.
2. **"Playwright wins, Puppeteer wrong by policy" was retired** per `feedback_browser_tool.md`. The standing rule is **pick the most efficient tool per task**, not vendor lock-in.

Decision tree (per `_audit/C-browser-stack.md` and `_validation/comparison.md`):

| Task | Use |
|---|---|
| Live page, Brent watching, want quick interactive check using his logged-in Chrome | `@browser` (Claude in Chrome). Precondition: extension installed AND `list_connected_browsers` non-empty. Currently NOT connected on this machine — separate one-time setup needed before this slot is usable. |
| One-off "what's on this page" without writing a runner file | Playwright MCP (post `claude mcp add playwright npx @playwright/mcp@latest`) — high token cost (~114k for typical multi-step task) but no script needed |
| **Visual QA harness, repeated runs, screenshots-to-disk, tested working today** | **Bash subprocess Playwright** — write a small Node script using locally-installed `playwright` (project-local install, NOT the broken CLI), run via Bash, save screenshots, `Read` them back. Verified against BB-Notes GH Pages 2026-05-10: status 200, 4.4s end-to-end, both viewports, full DOM probe. |
| Multi-city scrape, scheduled regression | `playwright` npm package + script (same Bash pattern) |
| GitHub write fallback when `github-mcp-server` is down | Chrome MCP `javascript_tool` (very narrow use case; not for visual QA) |

**Default for this agent:** Bash-subprocess Playwright. The other surfaces are listed so the agent knows when to switch.

## Prerequisites
- Node.js 18+ on PATH
- `playwright` installed in the target repo or workspace (`npm install --save-dev playwright@1.50.0` — pin the version; never `^`/`~`)
- `npx playwright install chromium` (one-time per machine, after every Playwright version bump)
- `.claude/settings.local.json` with sandbox network allowlist for the target URL if it's outside the default allowlist (per the standing rules' Sandbox / Network section). **Note (2026-05-10): `*.github.io` is NOT currently blocked for at least the BB-Notes URL on Brent's machine — verify before assuming the workaround is needed.**
- Target URL + viewport sizes to check
- Optional: a baseline screenshot directory at `<repo>/qa/baselines/<viewport>.png`

## Playbook

### Step 1 — Warm up
Navigate Playwright to the target URL with `waitUntil: 'networkidle'`. Fail fast on timeout. Capture status code; non-200 is an immediate FAIL unless the spec says otherwise.

### Step 2 — Capture per viewport
For each viewport (mobile 390×844, tablet 768×1024, desktop 1280×900):
- Screenshot the full page (`fullPage: true`)
- Listen for `console` errors and `pageerror` events; collect them
- Listen for `response` events with status >= 400; collect them
- Read the screenshot back into context for visual inspection

### Step 3 — Functional check list
Run app-specific checks (kept in `qa-checks.md` per project):
- Primary user flow completes (e.g., for BB-Notes: password modal appears, dismiss, ADD-TO-NOW renders)
- No text overflow or clipping at any viewport
- Zero console errors on primary flow
- All visible links resolve (HEAD-check)

### Step 4 — Baseline diff
For each viewport:
- If `qa/baselines/<viewport>.png` exists, compute pixel diff %
- If diff > threshold (default 2%): FAIL, attach the (baseline, current, diff) triple
- If no baseline: produce one as `qa/baselines/<viewport>.png` and mark "BASELINE-NEW" (NOT a pass)

### Step 5 — Report
Write `qa/<YYYY-MM-DD>/report.md` with:
- Pass/Fail per viewport
- Screenshots in `qa/<YYYY-MM-DD>/<viewport>.png`
- Diffs in `qa/<YYYY-MM-DD>/diffs/`
- Console errors verbatim (no paraphrase)
- Network errors verbatim
- Total time
- **Visual review per V1-V5** (see below) for each screenshot

### Step 6 — Visual review per V1-V5 (mandatory)

Per CCC Standing Rules § Visual Review Discipline (added 2026-05-19 after the BB-Notes v4.3 CodeMirror incident where this agent's class of work shipped a fully-broken editor with all probes returning `hasX: true`).

For every screenshot reviewed, the report must include:

1. **V1 — Pixel observation.** Describe what you see: text colors, dominant typeface (serif/sans/mono), readability at-a-glance. BEFORE comparing to spec.
2. **V2 — Failure mode match.** The dispatch prompt should have named "broken looks like X." Confirm: did you see X? If the dispatch didn't name failure modes, request a tightened prompt instead of guessing.
3. **V3 — No probe-as-proof.** `hasX: true` proves element exists. Doesn't prove it renders correctly. Always pair with visual inspection.
4. **V4 — Reference cross-check.** If a known-good reference exists (`qa/baselines/` or `dogfood-refs/` or a competitor capture), name which one you compared against + whether the new capture is in the same visual family.
5. **V5 — Readability check.** Explicitly answer: "any text where foreground and background contrast is too low to read?" Yes/no/where.

A screenshot lacking V1-V5 evidence is "not visually verified" — not PASS.

## Success Criteria
- All viewports screenshotted, diffed, and `Read` back into context
- Zero console errors on primary flow
- Diff threshold honored OR explicit baseline-update approval ("go" from Brent before re-baselining)
- Baseline updates land in a separate commit from the QA run

## Failure Modes & Recovery

| Failure | Cause | Fix |
|---|---|---|
| `403 host_not_allowed` / `ERR_INVALID_AUTH_CREDENTIALS` | Sandbox proxy blocks the host | Add to `.claude/settings.local.json` `sandbox.network.allowedDomains` |
| `Executable doesn't exist at …\ms-playwright\chromium-…` | Browser binary version drift | `npx playwright install chromium` |
| `@playwright/cli` daemon crashes (`Pipe.onStreamRead`) | Known broken on Brent's Windows + Node stack | Don't use the CLI. Use Bash-subprocess Playwright instead. |
| `@browser` says "Chrome extension not detected" | Extension not connected (current state on Brent's machine) | One-time setup: install extension, `/chrome` → "Reconnect extension" |
| `waitForSelector` timeout on a known element | App's mock-data didn't inject before scripts ran (when using a harness) | Confirm `addInitScript({path: 'mock-data.js'})` is called BEFORE `page.goto()` |
| Tests pass locally, fail a week later | Playwright version drift | Pin `playwright` in `package.json` (no `^`/`~`); add `npx playwright install chromium` to repo setup script |
| CAPTCHA / login wall / `alert()` modal | `@browser` pauses for human; Playwright auto-handles dialogs | For unattended runs: `page.on('dialog', d => d.accept())` |

## Output Artifacts
- `qa/<YYYY-MM-DD>/<viewport>.png` — per-viewport screenshots
- `qa/<YYYY-MM-DD>/diffs/<viewport>.png` — baseline diffs
- `qa/<YYYY-MM-DD>/report.md` — pass/fail report with verbatim error logs
- `qa/baselines/<viewport>.png` — committed baselines (separate commit when updated)
