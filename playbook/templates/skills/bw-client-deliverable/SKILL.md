---
name: bw-client-deliverable
description: Use when packaging the final deliverable for a Billington Works client engagement. Produces the standard bundle (HANDOFF.md, generated README, .claude/ config, AI contract addendum reference) and validates the deliverable against the Billington Works checklist. Do not use for Halff deliverables or internal-only work.
when_to_use: The user mentions client handoff, Billington Works deliverable, final package, end-of-project wrap, or `/ship-to-client`.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
disable-model-invocation: true
user-invocable: true
---

# Billington Works Client Deliverable Skill

User-invocable only (do not auto-trigger on keyword match — it has side effects). See ANTI_PATTERNS.md A14.

## Required deliverable components

1. **HANDOFF.md** at repo root
   - Goal (one sentence)
   - Progress (what's done, linked to files/commits)
   - What worked
   - What didn't work + reasons (critical — don't omit failed approaches)
   - Next steps (ordered)
   - Known bugs / limitations
2. **README.md** — generated via the auto-README procedure; hand-editing limited to the "Ops" section
3. **`.claude/` directory** — project-scoped settings, skills, agents (no personal `~/.claude` contents)
4. **AI contract addendum reference** — link to Billington Works AI Addendum v1 (kept outside the repo, in `bw-contracts/`)
5. **Case-study draft** (one page) — problem, solution, time-to-ship, cost, metrics. Marked `draft` until Brent edits.
6. **Transcript export** (optional) — if the client asked for one or the contract requires an audit trail, export via simonw/claude-code-transcripts and place in `docs/transcripts/`.

## Validation gates (all must pass before handoff)

- [ ] No secret patterns in repo (run `secret-scan-preedit.sh` across git history, not just HEAD)
- [ ] No Halff branding unless explicitly sub-licensed
- [ ] All `.env*` files in `.gitignore`
- [ ] `settings.json` denies reads of `.env*, *.pem, *.key, secrets/**`
- [ ] HANDOFF.md present and non-empty
- [ ] README covers: install, run, deploy, contact
- [ ] Test suite (if any) passing on main
- [ ] License file appropriate to client agreement

## Procedure

1. Scan repo for missing deliverable components. Report the gap list.
2. For each present component, validate against the gate list above.
3. If any HARD fail (secret, Halff bleed, missing HANDOFF), stop and report. Do not auto-fix sensitive issues.
4. Produce `deliverables/DELIVERY_CHECKLIST.md` with pass/fail per gate.
5. On all-green, emit the zip command per standing rules (only changed files, timestamps in Central Time).

## Non-negotiables

- Never commit the AI addendum PDF to the client repo (keep in private `bw-contracts/`).
- Never auto-fix gate failures involving secrets or branding.
- Always dry-run before the final zip.

## Pairs with

- `apps-script-deployer` if deliverable includes Apps Script code
- `halff-brand-compliance` in reverse — this skill rejects Halff branding for BW deliverables
