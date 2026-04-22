# CLAUDE.md — Google Apps Script (Canvassing / Signs Map family)

## Build / Run

```
npm install -g @google/clasp          # one-time
clasp login                           # one-time per machine
clasp push                            # deploy to Google from repo
clasp logs --watch                    # tail runtime logs
```

Stable versioned deployment ID must not change. URL in `config.js` depends on it.

---

## Prime rules

1. MUST use CLASP. Never paste code into the Apps Script browser editor.
2. MUST wrap equality checks: `String(a) === String(b)`.
3. MUST NOT create a new deployment unless explicitly told to. Keep the stable URL.
4. MUST keep the dev password (`choochoo`) out of `apps_script.js` — use PropertiesService.
5. MUST NOT read Sheet data via fetch-from-web patterns when `google_workspace_mcp` is available.

---

## Stack

- Runtime: Apps Script V8
- Data: Google Sheets (drive via `google_workspace_mcp` for reads/writes in-session)
- Deploy: CLASP
- Client sharing: single stable deployment URL → embedded in `config.js` of consuming web apps

## File layout

```
apps_script.js            # main entry
modules/
├── auth.gs
├── routes.gs
└── data.gs
appsscript.json           # manifest
.clasp.json               # scriptId — never change without deliberate reason
config_template.js        # example (no secrets)
```

## Conventions

- Use `PropertiesService.getScriptProperties()` for API keys / passwords
- Log via `console.log` + `clasp logs` rather than `Logger.log`
- `doGet` / `doPost` endpoints: always return JSON with a top-level `ok: true|false`
- Retry patterns: exponential backoff up to 3 attempts; fail explicitly on the 4th

## What NOT to do

- Don't deploy a new version when you mean to push code
- Don't use `== `without `String()` coercion on both sides
- Don't hardcode IDs / URLs; pull from script properties or a config constant at file top
- Don't swallow errors silently — log with enough context to debug from the runtime log alone

## Last 5 lines — pre-push

- `String()` coercion on every equality?
- `.clasp.json` still points at the correct scriptId?
- No secrets in committed files?
- Consuming web app still points at the same deployment URL?
- `clasp logs` clean after the push?
