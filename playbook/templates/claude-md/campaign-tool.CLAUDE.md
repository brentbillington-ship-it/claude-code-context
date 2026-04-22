# CLAUDE.md — Campaign Tool (Canvassing Map / Signs Map family)

## Build / Run

```
# Web layer (GitHub Pages)
python -m http.server 8080         # quick local static serve
# Apps Script layer
clasp push                          # deploy code to Google
# Data layer
py -m scripts.sync_voterfile        # refresh voter data in Sheet
```

Passwords: `choochoo` (dev). Never committed. Kept in `CLAUDE.local.md`.

---

## Prime rules

1. MUST use CLASP for all Apps Script deploys. Never the browser editor.
2. MUST use `String()` coercion on both sides of Apps Script equality checks.
3. MUST use `google_workspace_mcp` for Sheet reads/writes in-session (not CLASP).
4. MUST keep voter-file data out of git history. `output/`, `data/raw/`, `.cache/` in `.gitignore`.
5. MUST bump `version.js` + `?v=` query strings on every GitHub Pages release.

---

## Stack

- Map: Leaflet.js; tiles from configured provider per deploy
- Data: Google Sheets (driven by Apps Script) — URL in `config.js` must not change between releases
- ETL: Python pipeline using `campaign-data-processor` skill
- Auth: Sheet-ID + dev password only; never OAuth secrets in client code

## File layout

```
src/
├── index.html
├── map.js
├── config.js            # stable; NEVER break URL
├── version.js
apps_script.js            # mirrored to Google; `clasp push` is the bridge
scripts/
└── sync_voterfile.py    # uses campaign-data-processor skill
.claude/
```

## Conventions

- Timestamps in Central Time.
- Voter PII never in logs or commit messages.
- Layer prefixes / columns: `precinct`, `district`, `party_score`, `last_voted` — do not rename.
- Every deploy: screenshot before/after published with the release note.

## What NOT to do

- Don't create a new Apps Script deployment (new URL breaks `config.js`).
- Don't commit the raw voter file to the repo. Ever.
- Don't push to main without running the visual QA agent on a local Playwright preview.
- Don't expose the admin Sheet ID to the client-side bundle.

## Last 5 lines — pre-push

- Voter PII absent from the diff?
- `version.js` bumped?
- Apps Script pushed with `clasp push`?
- Map loads without console errors?
- Dev password still in `CLAUDE.local.md`, not `CLAUDE.md`?
