# Browser Bootstrap Agent

> **One-time setup of a local visual test harness for Canvassing Map in the CC container. Solves all CDN/network/auth blockers so QA agents can just run screenshots.**

## When to Invoke
- First time running visual QA in a new CC session
- After `AGENTS_VISUAL_QA.md` reports "harness not found" or "server failed"
- After any change to the app's login flow, external dependencies, or file structure

## Problem This Solves

The CC container blocks all domains except: `registry.npmjs.org`, `github.com`, `pypi.org`, `api.anthropic.com`, and a few others. This means:
- `cdn.playwright.dev` → BLOCKED (can't install Playwright browsers)
- `unpkg.com` → BLOCKED (Leaflet CDN fails)
- `fonts.googleapis.com` → BLOCKED (CSS @import hangs indefinitely)
- `brentbillington-ship-it.github.io` → BLOCKED (can't test live site)

**Solution:** Puppeteer (bundles Chromium, no CDN needed) + local HTTP server that serves everything from `node_modules` and stubs all external calls.

## Prerequisites
- Node.js available in CC container (it is by default)
- Repo cloned locally

## Playbook

### Step 1 — Install Dependencies

```bash
cd /path/to/Canvassing-Map
npm init -y 2>/dev/null || true
npm install puppeteer leaflet --save-dev
```

Puppeteer downloads its own Chromium from `storage.googleapis.com` — if that's blocked, use:
```bash
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer --save-dev
# Then find system chromium:
which chromium-browser || which chromium || which google-chrome
# Use that path in executablePath option
```

Verify:
```bash
node -e "const p = require('puppeteer'); console.log('Puppeteer OK, chrome at:', p.executablePath())"
```

### Step 2 — Create Test Harness Directory

```bash
mkdir -p tests/harness/screenshots
```

### Step 3 — Create the Local Test Server

Create `tests/harness/server.js`:

```javascript
const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');
const PORT = 8765;

const MIME = {
  '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.json': 'application/json',
  '.svg': 'image/svg+xml', '.ico': 'image/x-icon'
};

// Map CDN URLs to local node_modules paths
const CDN_REWRITES = {
  '/leaflet@1': '/node_modules/leaflet/dist',
  'unpkg.com/leaflet': null, // handled by rewrite
};

const server = http.createServer((req, res) => {
  let urlPath = req.url.split('?')[0];

  // Rewrite Leaflet CDN requests to node_modules
  if (urlPath.includes('leaflet') && urlPath.includes('unpkg')) {
    if (urlPath.endsWith('.css')) urlPath = '/node_modules/leaflet/dist/leaflet.css';
    else if (urlPath.endsWith('.js')) urlPath = '/node_modules/leaflet/dist/leaflet.js';
  }

  // Block Google Fonts (return empty CSS)
  if (urlPath.includes('fonts.googleapis.com') || urlPath.includes('fonts.gstatic.com')) {
    res.writeHead(200, { 'Content-Type': 'text/css' });
    return res.end('/* fonts stripped */');
  }

  // Serve parcels-stub instead of real 20MB parcels.js if stub exists
  if (urlPath === '/js/parcels.js' && fs.existsSync(path.join(__dirname, 'parcels-stub.js'))) {
    const stub = fs.readFileSync(path.join(__dirname, 'parcels-stub.js'));
    res.writeHead(200, { 'Content-Type': 'text/javascript' });
    return res.end(stub);
  }

  // Serve test page at root if using harness
  if (urlPath === '/test') {
    const testPage = path.join(__dirname, 'test-page.html');
    if (fs.existsSync(testPage)) {
      res.writeHead(200, { 'Content-Type': 'text/html' });
      return res.end(fs.readFileSync(testPage));
    }
  }

  // Normal file serving from repo root
  let filePath = path.join(ROOT, urlPath);
  if (urlPath === '/' || urlPath === '/index.html') {
    filePath = path.join(ROOT, 'index.html');
  }

  if (!fs.existsSync(filePath)) {
    res.writeHead(404);
    return res.end('Not found: ' + urlPath);
  }

  if (fs.statSync(filePath).isDirectory()) {
    filePath = path.join(filePath, 'index.html');
  }

  const ext = path.extname(filePath);
  let content = fs.readFileSync(filePath);

  // Strip Google Fonts @import from CSS files
  if (ext === '.css') {
    content = content.toString().replace(/@import\s+url\([^)]*fonts\.googleapis\.com[^)]*\)\s*;?/g, '/* font import stripped */');
  }

  // Rewrite CDN URLs in HTML files to local paths
  if (ext === '.html') {
    content = content.toString()
      .replace(/https?:\/\/unpkg\.com\/leaflet@[^"']*\/dist\/leaflet\.css/g, '/node_modules/leaflet/dist/leaflet.css')
      .replace(/https?:\/\/unpkg\.com\/leaflet@[^"']*\/dist\/leaflet\.js/g, '/node_modules/leaflet/dist/leaflet.js')
      .replace(/@import\s+url\([^)]*fonts\.googleapis\.com[^)]*\)\s*;?/g, '/* font import stripped */');
  }

  res.writeHead(200, { 'Content-Type': MIME[ext] || 'application/octet-stream' });
  res.end(content);
});

server.listen(PORT, () => console.log(`Harness server on http://localhost:${PORT}`));
module.exports = server;
```

### Step 4 — Create Parcels Stub

Create `tests/harness/parcels-stub.js` — minimal parcels data for testing:

```javascript
// Stub: 10 parcels covering the test area around map center [32.972, -96.978]
// Real parcels.js is 20MB+ — this stub is enough for visual QA
var PARCELS = [
  // Addresses that should appear in BOTH hanger and knock zones (dedup test)
  { address: "100 TEST ST", lat: 32.972, lng: -96.978, coords: [[32.9719,-96.9781],[32.9719,-96.9779],[32.9721,-96.9779],[32.9721,-96.9781]] },
  { address: "102 TEST ST", lat: 32.9722, lng: -96.978, coords: [[32.9721,-96.9781],[32.9721,-96.9779],[32.9723,-96.9779],[32.9723,-96.9781]] },
  { address: "104 TEST ST", lat: 32.9724, lng: -96.978, coords: [[32.9723,-96.9781],[32.9723,-96.9779],[32.9725,-96.9779],[32.9725,-96.9781]] },
  { address: "106 TEST ST", lat: 32.9726, lng: -96.978, coords: [[32.9725,-96.9781],[32.9725,-96.9779],[32.9727,-96.9779],[32.9727,-96.9781]] },
  { address: "108 TEST ST", lat: 32.9728, lng: -96.978, coords: [[32.9727,-96.9781],[32.9727,-96.9779],[32.9729,-96.9779],[32.9729,-96.9781]] },
  // Hanger-only addresses
  { address: "200 HANG LN", lat: 32.973, lng: -96.979, coords: [[32.9729,-96.9791],[32.9729,-96.9789],[32.9731,-96.9789],[32.9731,-96.9791]] },
  { address: "202 HANG LN", lat: 32.9732, lng: -96.979, coords: [[32.9731,-96.9791],[32.9731,-96.9789],[32.9733,-96.9789],[32.9733,-96.9791]] },
  // Knock-only addresses
  { address: "300 KNOCK DR", lat: 32.971, lng: -96.977, coords: [[32.9709,-96.9771],[32.9709,-96.9769],[32.9711,-96.9769],[32.9711,-96.9771]] },
  { address: "302 KNOCK DR", lat: 32.9712, lng: -96.977, coords: [[32.9711,-96.9771],[32.9711,-96.9769],[32.9713,-96.9769],[32.9713,-96.9771]] },
  { address: "304 KNOCK DR", lat: 32.9714, lng: -96.977, coords: [[32.9713,-96.9771],[32.9713,-96.9769],[32.9715,-96.9769],[32.9715,-96.9771]] },
];
```

### Step 5 — Create Mock SheetsAPI Response

Create `tests/harness/mock-data.js` — loaded before the app to intercept SheetsAPI:

```javascript
// Mock SheetsAPI — intercepts before real module loads
window.MOCK_MODE = true;

// Override SheetsAPI globally
window.SheetsAPI = {
  _mockTurfs: [
    {
      id: 'turf-hanger-1',
      name: 'Test Hanger Zone',
      mode: 'hanger',
      color: '#4CAF50',
      assignee: 'TestUser',
      polygon: [[32.969,-96.981],[32.969,-96.975],[32.975,-96.975],[32.975,-96.981]],
      houses: [
        { id: 'h1', address: '100 TEST ST', lat: 32.972, lng: -96.978, hangResult: '', knockResult: '' },
        { id: 'h2', address: '102 TEST ST', lat: 32.9722, lng: -96.978, hangResult: 'hung', knockResult: '' },
        { id: 'h3', address: '104 TEST ST', lat: 32.9724, lng: -96.978, hangResult: 'skip', knockResult: '' },
        { id: 'h4', address: '200 HANG LN', lat: 32.973, lng: -96.979, hangResult: 'hung', knockResult: '' },
        { id: 'h5', address: '202 HANG LN', lat: 32.9732, lng: -96.979, hangResult: '', knockResult: '' },
      ]
    },
    {
      id: 'turf-knock-1',
      name: 'Test Knock Zone',
      mode: 'knock',
      color: '#FF9800',
      assignee: 'TestUser',
      polygon: [[32.969,-96.980],[32.969,-96.974],[32.975,-96.974],[32.975,-96.980]],
      houses: [
        // Overlapping addresses (shared with hanger zone — dedup test)
        { id: 'k1', address: '100 TEST ST', lat: 32.972, lng: -96.978, hangResult: '', knockResult: 'not_home' },
        { id: 'k2', address: '102 TEST ST', lat: 32.9722, lng: -96.978, hangResult: '', knockResult: 'knocked' },
        { id: 'k3', address: '104 TEST ST', lat: 32.9724, lng: -96.978, hangResult: '', knockResult: 'not_interested' },
        // Knock-only addresses
        { id: 'k4', address: '300 KNOCK DR', lat: 32.971, lng: -96.977, hangResult: '', knockResult: 'knocked' },
        { id: 'k5', address: '302 KNOCK DR', lat: 32.9712, lng: -96.977, hangResult: '', knockResult: '' },
        { id: 'k6', address: '304 KNOCK DR', lat: 32.9714, lng: -96.977, hangResult: '', knockResult: 'skip' },
      ]
    }
  ],

  loadData: function() {
    return Promise.resolve(this._mockTurfs);
  },
  setResult: function(houseId, knockResult, user, hangResult, knockVal) {
    console.log('[MOCK] setResult:', { houseId, knockResult, user, hangResult, knockVal });
    return Promise.resolve({ success: true });
  },
  addHouse: function(data) {
    console.log('[MOCK] addHouse:', data);
    return Promise.resolve({ success: true, id: 'mock-' + Date.now() });
  },
  moveHouse: function(houseId, newTurfId) {
    console.log('[MOCK] moveHouse:', { houseId, newTurfId });
    return Promise.resolve({ success: true });
  },
  getUser: function() { return 'TestUser'; },
  getUsers: function() { return Promise.resolve(['TestUser']); },
  removeHouse: function() { return Promise.resolve({ success: true }); },
  setZoneColor: function() { return Promise.resolve({ success: true }); },
  setZoneAssignee: function() { return Promise.resolve({ success: true }); },
};

// Mock TurfDraw
window.TurfDraw = {
  init: function() {},
  enable: function() {},
  disable: function() {},
  setMode: function() {},
};

// Bypass login — inject user into localStorage
localStorage.setItem('canvass_user', JSON.stringify({ name: 'TestUser', email: 'test@test.com' }));
```

### Step 6 — Create the QA Runner Script

Create `tests/harness/qa-visual.js`:

```javascript
const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

const SCREENSHOT_DIR = path.join(__dirname, 'screenshots');
const PORT = 8765;

(async () => {
  // Ensure screenshot dir exists
  if (!fs.existsSync(SCREENSHOT_DIR)) fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });

  // Start local server
  const server = require('./server.js');

  // Wait for server to be ready
  await new Promise(r => setTimeout(r, 1000));

  // Launch browser
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-web-security'],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: 1400, height: 900 });

  // Collect console messages
  const consoleMsgs = [];
  const consoleErrors = [];
  page.on('console', msg => {
    consoleMsgs.push(`[${msg.type()}] ${msg.text()}`);
    if (msg.type() === 'error') consoleErrors.push(msg.text());
  });

  // Block external requests that would hang
  await page.setRequestInterception(true);
  page.on('request', req => {
    const url = req.url();
    // Allow localhost and data URIs
    if (url.startsWith('http://localhost') || url.startsWith('data:')) {
      req.continue();
      return;
    }
    // Block everything external
    console.log(`[BLOCKED] ${url}`);
    req.abort('blockedbyclient');
  });

  console.log('\n=== CANVASSING MAP VISUAL QA ===\n');

  try {
    // Navigate to local app
    console.log('Loading app...');
    await page.goto(`http://localhost:${PORT}/`, {
      waitUntil: 'domcontentloaded',
      timeout: 15000
    });

    // Wait for Leaflet map container
    await page.waitForTimeout(3000);

    // Check if login screen is showing — handle it
    const loginVisible = await page.evaluate(() => {
      const pwInput = document.getElementById('pw-input');
      const loginScreen = document.getElementById('login-screen');
      return (pwInput && pwInput.offsetParent !== null) || (loginScreen && loginScreen.offsetParent !== null);
    });

    if (loginVisible) {
      console.log('Login screen detected — entering password...');
      await page.type('#pw-input', 'choochoo');
      await page.click('#pw-btn');
      await page.waitForTimeout(5000);
    }

    // Wait for markers to render
    await page.waitForTimeout(5000);

    // === TEST: Version Check ===
    const title = await page.title();
    console.log(`Version: ${title}`);

    // === TEST: All Mode ===
    console.log('\n--- ALL MODE ---');
    // Select "All" in the view mode dropdown
    const hasViewMode = await page.evaluate(() => !!document.getElementById('view-mode-select'));
    if (hasViewMode) {
      await page.select('#view-mode-select', 'all');
    }
    await page.waitForTimeout(3000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'all-mode-z16.png') });

    let counts = await countMarkers(page);
    console.log(`  Zoom 16: ${counts.total} markers (${counts.circles} circles, ${counts.diamonds} diamonds)`);
    console.log(`  PASS: ${counts.circles > 0 && counts.diamonds > 0 ? 'YES — both shapes present' : 'FAIL — missing shapes'}`);

    // Zoom tests
    for (const zoom of [17, 18]) {
      await page.evaluate(z => {
        if (window.MapModule?.map) window.MapModule.map.setZoom(z);
        else if (window.L?.map) window.L.map.setZoom(z);
      }, zoom);
      await page.waitForTimeout(2000);
      await page.screenshot({ path: path.join(SCREENSHOT_DIR, `all-mode-z${zoom}.png`) });
      counts = await countMarkers(page);
      console.log(`  Zoom ${zoom}: ${counts.total} markers (${counts.circles} circles, ${counts.diamonds} diamonds)`);
      if (counts.diamonds === 0 && zoom > 16) {
        console.log(`  *** FAIL: Diamonds vanished at zoom ${zoom}! ***`);
      }
    }

    // === TEST: Hanger Mode ===
    console.log('\n--- HANGER MODE ---');
    if (hasViewMode) await page.select('#view-mode-select', 'hanger');
    await page.waitForTimeout(3000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'hanger-mode.png') });
    counts = await countMarkers(page);
    console.log(`  ${counts.total} markers (${counts.circles} circles, ${counts.diamonds} diamonds)`);
    console.log(`  PASS: ${counts.diamonds === 0 ? 'YES — zero diamonds' : 'FAIL — ' + counts.diamonds + ' diamonds in hanger mode!'}`);

    // === TEST: Knock Mode ===
    console.log('\n--- KNOCK MODE ---');
    if (hasViewMode) await page.select('#view-mode-select', 'knock');
    await page.waitForTimeout(3000);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'knock-mode.png') });
    counts = await countMarkers(page);
    console.log(`  ${counts.total} markers (${counts.circles} circles, ${counts.diamonds} diamonds)`);
    console.log(`  PASS: ${counts.circles === 0 ? 'YES — zero circles' : 'FAIL — ' + counts.circles + ' circles in knock mode!'}`);

    // === TEST: Marker Colors ===
    console.log('\n--- COLOR CHECK ---');
    if (hasViewMode) await page.select('#view-mode-select', 'all');
    await page.waitForTimeout(2000);
    const colors = await page.evaluate(() => {
      const markers = document.querySelectorAll('.leaflet-marker-pane .leaflet-marker-icon');
      const result = [];
      markers.forEach(m => {
        const bg = m.style.backgroundColor || window.getComputedStyle(m).backgroundColor;
        const cls = m.className || '';
        result.push({ class: cls, bg: bg, isDiamond: cls.includes('diamond') });
      });
      return result;
    });
    console.log(`  Found ${colors.length} markers with colors`);
    colors.forEach((c, i) => {
      console.log(`  [${i}] ${c.isDiamond ? 'DIAMOND' : 'CIRCLE'} bg=${c.bg} class=${c.class}`);
    });

    // === CONSOLE ERRORS ===
    console.log('\n--- CONSOLE ERRORS ---');
    if (consoleErrors.length === 0) {
      console.log('  PASS: Zero JS errors');
    } else {
      console.log(`  FAIL: ${consoleErrors.length} errors:`);
      consoleErrors.forEach(e => console.log(`    ${e}`));
    }

    // === SUMMARY ===
    console.log('\n=== SCREENSHOTS SAVED ===');
    const files = fs.readdirSync(SCREENSHOT_DIR).filter(f => f.endsWith('.png'));
    files.forEach(f => console.log(`  ${path.join(SCREENSHOT_DIR, f)}`));

  } catch (err) {
    console.error('QA FAILED:', err.message);
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, 'error-state.png') });
  }

  await browser.close();
  server.close();
  process.exit(0);
})();

async function countMarkers(page) {
  return page.evaluate(() => {
    const pane = document.querySelector('.leaflet-marker-pane');
    if (!pane) return { circles: 0, diamonds: 0, total: 0 };
    const all = pane.querySelectorAll('.leaflet-marker-icon');
    let circles = 0, diamonds = 0;
    all.forEach(m => {
      const cls = (m.className || '') + ' ' + (m.getAttribute('class') || '');
      if (cls.includes('diamond')) diamonds++;
      else circles++;
    });
    return { circles, diamonds, total: all.length };
  });
}
```

### Step 7 — Verify

```bash
cd /path/to/Canvassing-Map
node tests/harness/qa-visual.js
```

Expected output:
```
=== CANVASSING MAP VISUAL QA ===
Version: Canvassing Map v6.11
--- ALL MODE ---
  Zoom 16: X markers (Y circles, Z diamonds)
  PASS: YES — both shapes present
  Zoom 17: ...
  Zoom 18: ...
--- HANGER MODE ---
  X markers (Y circles, 0 diamonds)
  PASS: YES — zero diamonds
--- KNOCK MODE ---
  X markers (0 circles, Z diamonds)
  PASS: YES — zero circles
--- CONSOLE ERRORS ---
  PASS: Zero JS errors
=== SCREENSHOTS SAVED ===
```

Screenshots land in `tests/harness/screenshots/` — CC should `view` them to visually confirm.

---

## Success Criteria
- `npm install puppeteer leaflet` completes without error
- `node tests/harness/qa-visual.js` runs to completion
- Screenshots are saved and viewable
- All marker count checks pass

## Failure Modes & Recovery

| Failure | Cause | Fix |
|---|---|---|
| `puppeteer` install fails (Chromium download blocked) | `storage.googleapis.com` blocked | Set `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true`, use system `chromium-browser` with `executablePath` option |
| Page timeout on load | CSS @import hanging on Google Fonts | Verify server.js strips `@import url(*fonts.googleapis*)` from all CSS |
| No markers rendered | SheetsAPI mock not loaded | Verify `mock-data.js` is injected before app scripts via `page.evaluateOnNewDocument` or script tag in HTML |
| Login screen blocks | localStorage bypass didn't work | Add `page.evaluate` to set localStorage before navigation, or modify test page HTML to skip login |
| `leaflet.js` 404 | npm install leaflet didn't run | Run `npm install leaflet --save-dev` |
| Markers counted as 0 | Different CSS class names | Check actual marker HTML in browser, update selector in `countMarkers()` |

## Output Artifacts
- `node_modules/puppeteer/` — bundled Chromium
- `node_modules/leaflet/dist/` — local Leaflet CSS/JS
- `tests/harness/server.js` — local HTTP server with CDN rewriting
- `tests/harness/mock-data.js` — SheetsAPI + TurfDraw stubs
- `tests/harness/parcels-stub.js` — minimal parcels data
- `tests/harness/qa-visual.js` — QA runner with screenshots
- `tests/harness/screenshots/*.png` — visual evidence
