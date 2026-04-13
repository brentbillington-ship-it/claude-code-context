# Color Trace Agent

> **Trace a house through the full marker rendering pipeline to diagnose color, shape, visibility, and auto-set bugs.**

> ⚠️ **Retirement trigger:** All color/shape bugs resolved and stable for 2+ weeks. Check with Agent Manager.

## When to Invoke
- Specific house/address renders wrong color or shape
- Marker missing in one filter mode but present in another
- Auto-set not producing expected hanger result from knock result
- Dedup producing wrong winner at shared addresses

## Prerequisites
- Access to deployed `map.js` and `app.js` (curl from GitHub Pages or raw.githubusercontent.com)
- House ID or address to trace

---

## Playbook

### Step 1 — Identify the Target House

Get the house ID or address from Brent. If only address, normalize it:
```
Strip apartment/unit → uppercase → trim → remove trailing city/state/zip after comma
Example: "312 Oak Ln, Coppell, TX 75019" → "312 OAK LN"
```

### Step 2 — Pull Current Deployed Code
```bash
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/js/map.js" -o /home/claude/trace-map.js
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/js/app.js" -o /home/claude/trace-app.js
curl -sL "https://brentbillington-ship-it.github.io/Canvassing-Map/js/config.js" -o /home/claude/trace-config.js
```

### Step 3 — Trace Pipeline

For the target house, answer every cell in this table by reading the code:

| Step | Function | Line(s) | Value | Pass? |
|---|---|---|---|---|
| 1. Turf membership | `loadData` / turf loop | app.js | turfId=? mode=? | |
| 2. `isHangerZone` | set during turf parse | app.js | true/false | |
| 3. `isKnockZone` | set during turf parse | app.js | true/false | |
| 4. `hangResult` | from Sheet or auto-set | | value=? | |
| 5. `knockResult` | from Sheet or VOTER_KNOCKS | | value=? | |
| 6. Filter visibility | `_houseVisibleInFilter` | map.js | visible for hanger? knock? all? | |
| 7. Shape | `_getMarkerShape` | map.js | circle or diamond? | |
| 8. Color | `_getMarkerColor` | map.js | exact hex/name? | |
| 9. Dedup outcome | `_refreshVisibleMarkers` | map.js | kept or removed? replaced by? | |
| 10. Auto-set | `CONFIG.KNOCK_TO_HANG_AUTO[knockResult]` | config.js | expected hangResult=? | |
| 11. Auto-set guard | `_handleDualResult` | map.js | `preHouse.hangResult` empty? auto-set applied? | |
| 12. Sheet write | `SheetsAPI.setResult` | app.js | both values sent? | |

### Step 4 — Cross-Zone Trace (if address exists in both hanger + knock zones)

| Question | Answer |
|---|---|
| How many turf polygons contain this address? | |
| Which turfs? (IDs and modes) | |
| Does `_knockResultByAddr` find this address? | |
| Does `_mergeCrossZoneResults` process this house? | |
| After merge, what are hangResult and knockResult? | |
| After dedup, which marker survives? Shape? Color? | |

### Step 5 — Validate with Playwright (if available)

Use AGENTS_PLAYWRIGHT_QA.md Phase 5 approach to click the specific marker and inspect the popup state.

---

## Auto-Set Reference Table

| Knock Result Key | `CONFIG.KNOCK_TO_HANG_AUTO` Value | Expected Hanger Color |
|---|---|---|
| `not_home` | `hung` | Green |
| `knocked` | `hung` | Green |
| `not_interested` | `skip` | Black |
| `skip` | `skip` | Black |
| `come_back` | *(none — no auto-set)* | Unchanged |
| `moved` | *(none)* | Unchanged |

**Auto-set guard:** Only fires if `preHouse.hangResult` is falsy (empty/undefined). Existing non-grey hanger results are never overwritten.

---

## Output Format

Report as a single markdown table with the trace columns filled in, followed by:
- **DIAGNOSIS:** One sentence root cause.
- **FIX:** Specific line(s) and change needed.
- **VERIFY:** Which AGENTS_PLAYWRIGHT_QA.md check confirms the fix.

## Failure Modes & Recovery

| Symptom | Likely Root Cause |
|---|---|
| House visible in wrong filter mode | `isHangerZone`/`isKnockZone` flags wrong, or `_houseVisibleInFilter` has fallback bleed |
| Wrong color | `_getMarkerColor` branch mismatch, or `hangResult`/`knockResult` not populated |
| Missing after zoom | `_refreshVisibleMarkers` bounds check or dedup removing it |
| Auto-set not firing | Guard condition (`preHouse.hangResult` already set), or key mismatch in `CONFIG.KNOCK_TO_HANG_AUTO` |
| Dedup wrong winner | `_normalizeAddr` not matching across sources, or mode-based filter in dedup skipping the knock |
