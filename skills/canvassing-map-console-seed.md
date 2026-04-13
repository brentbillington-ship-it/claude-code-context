name: canvassing-map-console-seed
description: Browser-console seeding enhancements for the Canvassing Map project. Generates additive console snippets for bookmarklets, progress logging, resumable batching, and zone summaries. Never modifies tools/seed_missing_markers.js directly.
allowed-tools: Read Bash

## Context

Project: brentbillington-ship-it/Canvassing-Map
Stack: GitHub Pages + Google Sheets (Apps Script) + Leaflet.js

Missing residential parcel markers are seeded by pasting a script into the browser
console while logged in as admin on the live app. The base dry-run and live-seed logic
lives in `tools/seed_missing_markers.js` — always read that file first to get current
field names, array names, and loop structure before generating any snippet.

IMPORTANT: Playwright is NOT usable from the CC container. The proxy blocks GitHub
Pages and script.google.com. All work here produces console-paste snippets for the
user to run manually in the browser.

---

## Sub-Skills

### 1. BOOKMARKLET GENERATOR

Invoke when: user wants a one-click trigger from the browser bookmarks bar instead of
opening DevTools each time.

Steps:
1. Read tools/seed_missing_markers.js to get the current dry-run or live-seed function.
2. Identify which function the user wants bookmarkletted (dry-run or live-seed).
3. Minify the target function: strip comments, collapse whitespace, remove blank lines.
4. Wrap in a javascript: URI with an IIFE:
   ```
   javascript:(function(){<minified code>})();
   ```
5. Output the full javascript: string for the user to paste into a new bookmark's URL
   field.
6. Check character count. If the script exceeds 2 000 characters, warn the user and
   offer the fetch-and-eval pattern instead:
   ```js
   javascript:(function(){fetch('https://raw.githubusercontent.com/brentbillington-ship-it/Canvassing-Map/main/tools/seed_missing_markers.js').then(r=>r.text()).then(eval)})();
   ```
7. Remind the user: bookmark URL field, not the name field.

---

### 2. PROGRESS LOGGING

Invoke when: seeding more than ~50 gaps at once, or when the user wants visibility into
a long-running seed.

Steps:
1. Read tools/seed_missing_markers.js to identify the live-seed insert loop and the
   gaps array variable name.
2. Before the loop, add a counter:
   ```js
   let _seedCount = 0;
   const _seedTotal = gaps.length;
   console.log(`Starting seed — ${_seedTotal} gaps to insert.`);
   ```
3. Inside the loop, after each successful insert, increment and log every 10:
   ```js
   _seedCount++;
   if (_seedCount % 10 === 0 || _seedCount === _seedTotal) {
     console.log(`[${_seedCount}/${_seedTotal}] inserted`);
   }
   ```
4. After the loop, log a final summary:
   ```js
   console.log(`Done — ${_seedCount} of ${_seedTotal} markers inserted.`);
   ```
5. Output the complete modified live-seed block as a standalone console-paste snippet,
   not a file diff.

---

### 3. RESUMABLE BATCHING

Invoke when: seeding a dataset large enough that browser tab timeout or accidental
close is a real risk (>200 gaps), or when the user wants to seed one zone at a time.

Steps:
1. Read tools/seed_missing_markers.js to get the gaps array name and insert loop.
2. Add a persistent offset using window so it survives re-pastes in the same tab:
   ```js
   window._seedOffset = window._seedOffset || 0;
   const _BATCH_SIZE = 50; // increase if gaps are small / fast
   ```
3. Slice gaps before the insert loop:
   ```js
   const _batch = gaps.slice(window._seedOffset, window._seedOffset + _BATCH_SIZE);
   console.log(`Batch: rows ${window._seedOffset}–${window._seedOffset + _batch.length - 1} of ${gaps.length}`);
   ```
4. Run the existing insert loop over _batch instead of gaps.
5. After the loop, advance the offset and report:
   ```js
   window._seedOffset += _batch.length;
   if (window._seedOffset >= gaps.length) {
     console.log('All gaps seeded. Reset: window._seedOffset = 0');
   } else {
     console.log(`Paused. Re-paste to continue from offset ${window._seedOffset}.`);
   }
   ```
6. Do NOT bypass the existing sheet-read dedup check — the base script reads current
   sheet rows to build gaps; keep that intact so re-runs are safe.
7. Tell the user: re-paste the same snippet to process the next batch; run
   `window._seedOffset = 0` in the console to reset.
8. Output as a standalone console-paste snippet.

---

### 4. ZONE SUMMARY

Invoke when: user wants to seed selectively by zone, or wants a quick audit of which
zones have the most missing coverage.

Steps:
1. Read tools/seed_missing_markers.js to find the dry-run section that builds the gaps
   array and identify the exact field name used for zone (e.g. g.zone, g.Zone,
   g['Zone'], etc.).
2. After the gaps array is fully populated in the dry-run block, inject:
   ```js
   const _byZone = {};
   gaps.forEach(g => {
     const _z = g.zone || g.Zone || g['Zone'] || 'Unknown';
     _byZone[_z] = (_byZone[_z] || 0) + 1;
   });
   console.log('--- Zone Gap Summary ---');
   Object.entries(_byZone)
     .sort((a, b) => b[1] - a[1])
     .forEach(([z, n]) => console.log(`  ${z}: ${n} gap${n !== 1 ? 's' : ''}`));
   console.log(`  TOTAL: ${gaps.length} gaps`);
   ```
3. Replace the zone field accessor (`g.zone || g.Zone ...`) with the exact field name
   confirmed in step 1 — do not guess.
4. Output the complete modified dry-run block as a standalone console-paste snippet.
5. Remind the user: this is dry-run only. To seed a single zone, they can filter after
   seeing the summary by adding `.filter(g => g.Zone === 'Zone A')` before the insert
   loop in the live-seed snippet.
