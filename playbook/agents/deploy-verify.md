---
name: deploy-verify
description: Post-deploy smoke test against a live URL. Use immediately after `git push` to a GitHub Pages repo, after `clasp push` for Apps Script (also see `apps-script-deploy`), or after any production deploy the user signals. Confirms the build deployed, the version bumped, critical endpoints respond, and cache-bust ran. STOPs and asks if Apps Script deployment created a new URL (deployment-ID stability is a known foot-gun). Cross-project version of `AGENTS_DEPLOY_VERIFY.md` (Canvassing-Map specific).
tools: Read, Bash, WebFetch
model: sonnet
---

# deploy-verify

> **Purpose:** Post-deploy smoke test against a live URL. Confirms the build deployed, the version bumped, and critical endpoints respond. Cross-project — for the Canvassing-Map-specific flow see `AGENTS_DEPLOY_VERIFY.md` at the CCC root. For Apps Script-specific deployment risks see `apps-script-deploy`.

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
