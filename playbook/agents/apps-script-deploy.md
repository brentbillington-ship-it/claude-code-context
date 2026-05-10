---
name: apps-script-deploy
description: Deploy Apps Script projects via CLASP (NOT the browser editor — standing rule). Use when pushing Apps Script changes for Place-5-Tracker, Early-Voting-Tracker, sign-map, Sign_Routing, or any other Sheets-backed app. Verifies CLASP login, version pins, and — critically — checks that `clasp deploy` did NOT create a new deployment ID (the perennial "Apps Script created a new URL → all bookmarks broken" bug). Pairs with `deploy-verify` for the post-deploy smoke.
tools: Read, Glob, Grep, Bash, Write
model: sonnet
---

# apps-script-deploy

> **Purpose:** Deploy Apps Script via CLASP and verify deployment-ID stability. Apps Script's deployment model has a foot-gun: every `clasp deploy` without `--deploymentId` creates a NEW URL, which breaks every bookmark, every embedded link, every "saved app" the user has. This agent enforces stable redeploys.

Standing rule (S2 / Plugins): **never use the Apps Script browser editor.** All deploys go through CLASP. This agent is the canonical CLASP deploy flow.

## When to Invoke
- Apps Script change ready to deploy
- User says "push to Apps Script" or "deploy script"
- Repo has `.clasp.json` and `appsscript.json`
- After CLASP login (the agent verifies; doesn't authenticate for you)

## Prerequisites
- `clasp` installed globally: `npm install -g @google/clasp`
- `~/.clasprc.json` present (CLASP login completed: `clasp login`)
- Repo has `.clasp.json` (with `scriptId`) and `appsscript.json`
- For deploys: a record of the current deployment ID (in the repo's README or a `DEPLOYMENT.md`)
- Wrap the `apps-script-deployer` skill at `playbook/templates/skills/apps-script-deployer/SKILL.md` if installed

## Playbook

### Step 1 — Pre-flight checks
1. `clasp login --status` → must show authenticated
2. `clasp list-deployments` → snapshot the current state (deployment IDs + descriptions + version numbers)
3. Read `.clasp.json` → verify `scriptId` matches the expected project (foot-gun: wrong project deploy)
4. `git status` → working tree clean (no unstaged changes drift between local and what gets pushed)

### Step 2 — Push code
1. `clasp push` → uploads local files to script.google.com
2. `clasp pull --dry` → verify the round-trip is clean (no server-side files local doesn't have, no local-only files)

If `clasp push` reports "files would be deleted" — STOP. CLASP push deletes server-side files not in local. Confirm intent before proceeding.

### Step 3 — Version
1. `clasp version "<change description>"` → creates a new immutable version number
2. Note the version number for the deploy step

### Step 4 — Deploy with deployment ID stability
This is the critical step.

**Wrong way (creates a NEW URL — breaks every bookmark):**
```
clasp deploy --description "v1.2.3"
```

**Right way (updates existing deployment, URL stable):**
```
clasp deploy --deploymentId <existing-id> --description "v1.2.3" --versionNumber <version>
```

The `<existing-id>` comes from Step 1's snapshot. If there's no existing prod deployment yet (first deploy), then a fresh `clasp deploy` is correct — and the resulting deployment ID becomes the canonical one going forward. Record it in `DEPLOYMENT.md`.

### Step 5 — Verify deployment ID didn't drift
Run `clasp list-deployments` again. Compare against Step 1's snapshot:
- The deployment IDs should be IDENTICAL (just versions/descriptions updated)
- If a NEW deployment ID appeared, the deploy used the wrong flag — STOP, ask user before continuing (the new URL needs to either replace the old one in every consumer, or be retired)
- If the prod deployment ID is missing, the deploy DELETED it — surface immediately

### Step 6 — Post-deploy smoke
Hand off to `deploy-verify`:
- The web app URL (constructed from the deployment ID)
- Expected version string
- Critical endpoints to probe
- Cache-bust verification (Apps Script caches aggressively; bump query string or URL fragment)

### Step 7 — Record
Update `DEPLOYMENT.md`:
- Latest version number
- Latest deployment description
- The stable deployment ID (NEVER edit this without explicit go from user)
- Date/time + run notes

## Success Criteria
- `clasp push` returned no file-deletion warnings (or warnings were explicitly acknowledged)
- New version created with descriptive message
- Deployment ID unchanged from pre-flight snapshot
- `deploy-verify` smoke passes
- `DEPLOYMENT.md` updated

## Failure Modes & Recovery

| Failure | Cause | Fix |
|---|---|---|
| `clasp push` says "Multiple users have edited" | Browser-editor changes upstream of local | `clasp pull` to merge; reconcile; do not force-push without diff review |
| `clasp deploy` creates new ID despite `--deploymentId` flag | Flag value has typo or doesn't exist | Verify ID from `clasp list-deployments` — must match exactly |
| Version number doesn't increment | `clasp version` was skipped | Run `clasp version` before `clasp deploy --versionNumber` |
| Web app returns "Script function not found" after deploy | Deployment URL points at wrong file/function | Check `appsscript.json` → `webapp` entry; verify access settings |
| 403 on production URL after deploy | Sharing settings reverted (Apps Script defaults to "Only me") | `clasp deployments` won't show this; must check in script.google.com → Deploy → Manage Deployments |
| User reports "the app moved" | Deployment ID changed (this agent failed to enforce stability) | Restore previous deployment from version history; document in `DEPLOYMENT.md` why it happened |

## Output Artifacts
- Updated `DEPLOYMENT.md` in the target repo
- `deploy-log/<YYYY-MM-DD-HHmm>.md` with the pre/post deployment-ID snapshots and command outputs

## Related
- `deploy-verify` — generic post-deploy smoke for any URL
- Standing rules → Plugins → "CLASP + Apps Script Pack" + "never browser editor"
- `playbook/templates/skills/apps-script-deployer/SKILL.md` — reusable deploy skeleton
