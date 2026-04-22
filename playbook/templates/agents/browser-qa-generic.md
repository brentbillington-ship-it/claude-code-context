# browser-qa (generic)

> **Purpose:** Browser-based visual and functional QA against a live or local URL. Playwright-driven. Replaces any manual click-through for releases.

## When to Invoke
- Before any web-app deploy
- After a CSS or JS change that could shift layout
- When standing rules say "run visual QA" (Canvassing Map releases)

## Prerequisites
- Playwright CLI installed (`npm install -g @playwright/cli@latest`)
- Chromium installed (`playwright install chromium`)
- Target URL + viewport sizes to check

## Playbook

1. Warm up Playwright with `wait_until: "networkidle"` on the target URL. Fail fast if timeout.
2. For each viewport (mobile 375, tablet 768, desktop 1440):
   - Screenshot the full page
   - Capture console errors + unhandled rejections
   - Capture network 4xx/5xx
3. Run the functional check list (specific to the app; keep in `qa-checks.md`):
   - Primary user flow completes
   - No text overflow or clipping
   - No console errors
   - All links resolve
4. Diff screenshots against the baseline in `baselines/<viewport>.png`. Report diff % per viewport.
5. If any diff > threshold (default 2%), mark FAIL and attach the pair.
6. Produce a pass/fail report with screenshots.

## Success Criteria
- All viewports screenshotted + diffed
- Zero console errors on primary flow
- Diff threshold honored OR explicit baseline-update approval
- Baseline updates are tracked in a separate commit

## Failure Modes & Recovery
- Dev server not running → start it, retry once
- Auth blocks the page → use a `.auth.json` (gitignored) with a test-only session
- Baseline drift after a real visual change → propose baseline update as a separate commit, wait for "go"

## Output Artifacts
- `qa/<YYYY-MM-DD>/<viewport>.png`
- `qa/<YYYY-MM-DD>/diffs/`
- `qa/<YYYY-MM-DD>/report.md`
