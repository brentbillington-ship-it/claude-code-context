---
name: apps-script-deployer
description: Use when deploying Google Apps Script code from a local repo to a Google Apps Script project. Uses CLASP (never the browser editor). Maintains a stable versioned deployment so URLs in config.js never change. Do not use for one-off `.gs` snippet runs — open the Apps Script editor for those.
when_to_use: The user mentions CLASP, apps_script.js, Apps Script deploy, Apps Script push, gas-deploy, Canvassing App script, Signs Map script, or Google Apps Script release.
allowed-tools: Read, Write, Edit, Bash
disable-model-invocation: true
user-invocable: true
---

# Apps Script Deployer Skill

User-invocable. Matches the CLASP workflow in CLAUDE_CODE_STANDING_RULES.md § CLASP.

## Preconditions

- `clasp` installed globally: `npm install -g @google/clasp`
- `.clasp.json` present in project root
- Logged in (`clasp login`) and `scriptId` correct in `.clasp.json`
- Stable versioned deployment ID on record (never re-create — the URL in `config.js` depends on it)

## Procedure

1. Read `apps_script.js` (or the `.gs` files) — enumerate changed files since last push.
2. Confirm `.clasp.json` points at the correct script. Abort if the scriptId is unfamiliar.
3. Lint / syntax-check locally. Apps Script V8 runtime; use `String()` coercion on equality checks per standing rules.
4. `clasp push` — this updates the code on Google's side.
5. **Do not** run `clasp deploy` for a new version unless Brent explicitly asks; the stable versioned deployment ID should stay put.
6. Run a post-push smoke test: call `clasp logs --watch` briefly OR trigger the sheet's onEdit/doGet endpoint if there's a safe way to do so.
7. Report: what was pushed, what wasn't, any warnings from the `clasp push` output.

## Non-negotiables

- Never manually paste into the browser editor. Always CLASP. Standing rules hard rule.
- Never create a new deployment unless explicitly instructed.
- Equality checks: wrap both sides in `String()` (per standing rules § Code Delivery).
- Passwords (`choochoo` for Canvassing/Signs Map) via `CLAUDE.local.md`; never in `apps_script.js`.

## Pairs with

- `google_workspace_mcp` for reading/writing the Sheet data the script operates on (complementary — CLASP deploys code, workspace MCP touches data)
- `bw-client-deliverable` if Apps Script is part of a Billington Works delivery
