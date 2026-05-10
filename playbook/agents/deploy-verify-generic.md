# deploy-verify (generic)

> **Purpose:** Post-deploy smoke test against a live URL. Confirms the build deployed, the version bumped, and critical endpoints respond.

## When to Invoke
- Immediately after `git push` to a GitHub Pages repo
- After `clasp push` for Apps Script projects
- After any production deploy the user signals

## Prerequisites
- Live URL(s) for the deployed environment
- Expected version string (usually from `version.js`)
- A short list of endpoints / selectors to check

## Playbook

1. Read the deploy manifest: what was supposed to ship?
2. For each URL in the manifest:
   - Fetch the page root
   - Confirm the version string matches what was pushed
   - Confirm no 4xx/5xx in the page load
   - For JS apps: confirm a sentinel element renders (e.g., `#app`, `#map`)
3. For each critical endpoint (API, Apps Script `doGet`, webhook):
   - Send a harmless probe request (GET with `?probe=1` or similar)
   - Confirm the expected JSON structure
4. For cached assets: verify `?v=<new-version>` is present on script/style tags; if not, the cache-bust didn't ship.
5. Take screenshots on any anomaly (Playwright MCP or curl + ImageMagick fallback).
6. Produce a pass/fail report.

## Success Criteria
- Version string bumped and live
- All critical endpoints return expected shape
- Zero network errors in the first page load
- Screenshot attached to any failure

## Failure Modes & Recovery
- CDN cache → wait 30s, retry once, then flag "possible CDN propagation lag"
- Apps Script deploy created a NEW URL → STOP; the stable deployment discipline was broken. Notify the user, do not auto-proceed.
- 5xx from the root → do not retry in a loop; report immediately

## Output Artifacts
- `deploy-verify/<YYYY-MM-DDTHHMM>.md` — pass/fail per check
- Screenshots in `deploy-verify/screenshots/`
