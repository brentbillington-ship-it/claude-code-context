# Deploy Verify Agent

> **After any push to `main`, verify the deployed site serves the correct version and critical fix signatures are present.**

## When to Invoke
- Immediately after any `git push` to `main` on the Canvassing-Map repo
- When Brent reports "it didn't change" or "still seeing old version"
- Before closing any hotfix issue

## Prerequisites
- `curl` available
- Expected version string (from `version.js`)
- Optionally: Playwright (for live render test — see AGENTS_PLAYWRIGHT_QA.md)

---

## Playbook

### Step 1 — Wait for GitHub Pages Deploy
GitHub Pages typically deploys within 30-90 seconds. Wait 2 minutes after push.

### Step 2 — Version String Check
```bash
# Check version.js
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/js/version.js" | head -5

# Check index.html title
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/" | grep -i "<title>"

# Check cache busters
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/" | grep -oP '\?v=[0-9.]+'  | sort -u
```

**PASS:** All version strings match the expected version. All cache busters are identical.
**FAIL:** Mixed versions → stale cache. Old version → push didn't reach main, or Pages hasn't deployed yet.

### Step 3 — Fix Signature Grep

For each fix in the current hotfix, grep the deployed JS for the specific code pattern that confirms the fix is present.

Example signatures (update per release):
```bash
# v6.09: lookup scans ALL turfs (no mode === 'knock' filter)
curl -sL ".../js/app.js" | grep -c "mode.*knock.*return"
# Should be 0 (the filter was removed)

# v6.09: _normalizeAddr strips city/state
curl -sL ".../js/map.js" | grep -c "replace.*,\.\*"
# Should be >= 1

# v6.09: merge detects knock by data not turf mode
curl -sL ".../js/app.js" | grep -c "knockResult.*merge"
# Verify the pattern exists
```

### Step 4 — Branch Check
Verify `main` is the branch being deployed, not a stale branch:
```bash
# Via GitHub API (if accessible)
curl -sL "https://api.github.com/repos/brentbillington-ship-it/Canvassing-Map/commits/main" \
  -H "Authorization: token ghp_..." | grep -E '"message"|"date"' | head -4
```

If API is blocked from container, use Chrome MCP `javascript_tool` from a github.com tab.

### Step 5 — Quick Playwright Smoke (Optional)
If Playwright is installed, run a minimal check:
```javascript
const { chromium } = require('playwright');
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();
await page.goto('https://brentbillington-ship-it.github.io/Canvassing-Map/');
await page.fill('#pw-input', 'choochoo');
await page.click('#pw-btn');
await page.waitForTimeout(15000);

// Check for JS errors
const errors = [];
page.on('console', m => { if (m.type() === 'error') errors.push(m.text()); });

// Verify markers rendered
const markerCount = await page.evaluate(() =>
  document.querySelectorAll('.leaflet-marker-pane .leaflet-marker-icon').length
);

console.log(`Markers: ${markerCount}, Errors: ${errors.length}`);
await browser.close();
```

**PASS:** >0 markers, 0 JS errors.

---

## Success Criteria

| Check | Pass |
|---|---|
| `version.js` matches expected | YES/NO |
| All `?v=` cache busters match | YES/NO |
| `<title>` contains expected version | YES/NO |
| Fix signatures present in deployed JS | YES/NO |
| No mixed old/new version strings | YES/NO |
| (Optional) Playwright: markers render, 0 errors | YES/NO |

## Failure Modes & Recovery

| Failure | Fix |
|---|---|
| Old version still served | Wait 2 more minutes. Hard-refresh. Check that push went to `main` not a feature branch. |
| Mixed cache busters | `index.html` wasn't updated for all script/link tags. Fix and re-push. |
| Fix signature missing | Commit didn't include that file. Check `git log --stat` on main. |
| API blocked from container | Use Chrome MCP javascript_tool fallback for GitHub API calls. |

## Output Artifacts
- Console report with pass/fail table
- If Playwright used: `/home/claude/deploy-smoke.png`
