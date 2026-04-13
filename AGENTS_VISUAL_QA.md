# Visual QA Agent

> **Run visual screenshot QA of the Canvassing Map using Puppeteer against a local test harness. Validates marker shapes, colors, filter isolation, zoom persistence, and auto-set behavior with real rendered output.**

> Replaces the original `AGENTS_PLAYWRIGHT_QA.md` which assumed internet access. This version works in the CC container.

## When to Invoke
- After any push to `main` that touches `map.js`, `app.js`, `config.js`, or `index.html`
- When a visual bug is reported (wrong colors, missing markers, zoom-dependent rendering)
- As the final gate before closing any hotfix — **never skip this step**

## Prerequisites

**Run `AGENTS_BROWSER_BOOTSTRAP.md` first** if any of these are missing:
- `node_modules/puppeteer/` 
- `node_modules/leaflet/dist/`
- `tests/harness/server.js`
- `tests/harness/mock-data.js`
- `tests/harness/qa-visual.js`

Quick check:
```bash
ls tests/harness/qa-visual.js && echo "Harness ready" || echo "Run AGENTS_BROWSER_BOOTSTRAP.md first"
```

---

## Playbook

### Step 1 — Run the QA Suite

```bash
cd /path/to/Canvassing-Map
node tests/harness/qa-visual.js
```

This:
1. Starts a local HTTP server on port 8765
2. Rewrites all CDN URLs to local `node_modules/`
3. Strips Google Fonts imports from CSS
4. Stubs parcels.js with lightweight test data
5. Mocks SheetsAPI with known test cases
6. Launches headless Chromium via Puppeteer
7. Tests All / Hanger / Knock modes
8. Tests zoom levels 16 / 17 / 18
9. Counts markers by shape (circle vs diamond)
10. Checks for console JS errors
11. Saves screenshots to `tests/harness/screenshots/`

### Step 2 — Review Screenshots

```bash
# View each screenshot
view tests/harness/screenshots/all-mode-z16.png
view tests/harness/screenshots/all-mode-z17.png
view tests/harness/screenshots/all-mode-z18.png
view tests/harness/screenshots/hanger-mode.png
view tests/harness/screenshots/knock-mode.png
```

**What to look for visually:**

| Screenshot | Expected |
|---|---|
| `all-mode-z16.png` | Mix of circles (hanger-only addresses) and diamonds (knock zone addresses). Green, black, grey, and colored markers. |
| `all-mode-z17.png` | Same markers as z16 — nothing should vanish. |
| `all-mode-z18.png` | Same markers as z16/z17 — zoom persistence confirmed. |
| `hanger-mode.png` | ONLY circles. Zero diamonds. Green (hung), black (skip), grey (untouched). |
| `knock-mode.png` | ONLY diamonds. Zero circles. Yellow (knocked), red (not_home), black (skip/refused), grey (untouched). |

### Step 3 — Check Pass/Fail Table

The console output gives a structured report. All of these must pass:

| Check | Pass Condition |
|---|---|
| All mode: both shapes | circles > 0 AND diamonds > 0 |
| All mode: zoom 17 | diamonds > 0 (didn't vanish) |
| All mode: zoom 18 | diamonds > 0 (didn't vanish) |
| Hanger mode: isolation | diamonds === 0 |
| Knock mode: isolation | circles === 0 |
| Console errors | 0 JS errors |

### Step 4 — If Any Check Fails

1. Screenshot the failure state (`error-state.png` is saved automatically on crash)
2. **Invoke `AGENTS_COLOR_TRACE.md`** for the specific failing behavior
3. Fix the code
4. Bump version in `version.js` + cache busters in `index.html`
5. **Re-run this agent** — do not close the issue without a clean pass

---

## Mock Data Test Cases

The harness mock data (`tests/harness/mock-data.js`) includes these specific test cases:

| Address | Hanger Turf | Knock Turf | Expected in All Mode |
|---|---|---|---|
| 100 TEST ST | hangResult: '' | knockResult: 'not_home' | Diamond, auto-set → green from hung |
| 102 TEST ST | hangResult: 'hung' | knockResult: 'knocked' | Diamond, green (hung takes priority) |
| 104 TEST ST | hangResult: 'skip' | knockResult: 'not_interested' | Diamond, black |
| 200 HANG LN | hangResult: 'hung' | *(not in knock zone)* | Circle, green |
| 202 HANG LN | hangResult: '' | *(not in knock zone)* | Circle, grey |
| 300 KNOCK DR | *(not in hanger zone)* | knockResult: 'knocked' | Diamond, yellow/blue |
| 302 KNOCK DR | *(not in hanger zone)* | knockResult: '' | Diamond, grey |
| 304 KNOCK DR | *(not in hanger zone)* | knockResult: 'skip' | Diamond, black |

To add more test cases, edit `tests/harness/mock-data.js` and add houses to the appropriate turf.

---

## Extending the QA Suite

### Adding a Popup / Auto-Set Click Test

Add to `qa-visual.js` after the color check:

```javascript
// Click a diamond marker and verify popup
const diamondClicked = await page.evaluate(() => {
  const d = document.querySelector('.leaflet-marker-icon.diamond');
  if (d) { d.click(); return true; }
  return false;
});

if (diamondClicked) {
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'popup-open.png') });
  const popupText = await page.evaluate(() => {
    const popup = document.querySelector('.leaflet-popup-content');
    return popup ? popup.innerText : null;
  });
  console.log('Popup content:', popupText);
}
```

### Adding a Real Data Test (if internet access becomes available)

Replace `mock-data.js` with the real SheetsAPI by removing the request interception for `script.google.com`. The rest of the harness (CDN rewriting, font stripping) still applies.

---

## Failure Modes & Recovery

| Failure | Likely Cause | Fix |
|---|---|---|
| "Harness not found" | Bootstrap not run | Run `AGENTS_BROWSER_BOOTSTRAP.md` |
| Server won't start (port in use) | Previous run didn't clean up | `kill $(lsof -t -i:8765)` then retry |
| Page loads but no markers | Mock data not injected | Check that `mock-data.js` loads before app scripts |
| All markers are grey | Results not being read from mock houses | Check `SheetsAPI.loadData()` return format matches what `App.loadData()` expects |
| Screenshot is blank/white | Page didn't render | Check `error-state.png`, increase waitForTimeout |
| Puppeteer launch fails | No Chromium | `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true`, use `executablePath: '/usr/bin/chromium-browser'` |

## Output Artifacts
- `tests/harness/screenshots/*.png` — visual evidence (view these!)
- Console pass/fail table
