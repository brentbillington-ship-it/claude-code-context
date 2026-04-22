# CLAUDE.md — Billington Works Client Deliverable

## This repo will be handed to a paying client. Handle accordingly.

## Build / Run

```
# every client repo starts from the bw-project-template
gh repo create --template brentbillington-ship-it/bw-project-template <client>-<project>
# then, inside the cloned repo:
./scripts/bootstrap.sh
```

---

## Prime rules — non-negotiable

1. MUST have a `.claude/settings.json` that denies reads of `.env*, *.pem, *.key, secrets/**`.
2. MUST NOT contain any Halff branding, templates, or reusable assets.
3. MUST produce `HANDOFF.md` before delivery (use the `bw-client-deliverable` skill).
4. MUST run `secret-scan-preedit.sh` across full git history before every push, not just HEAD.
5. MUST attach the Billington Works AI Addendum as a linked reference — not an embedded PDF.

---

## Deliverable bundle

Every deliverable includes:

- `README.md` — auto-generated, with hand-edited "Ops" section
- `HANDOFF.md` — goal, progress, what worked, what didn't, next steps (required)
- `.claude/` — project-scoped config only; no personal `~/.claude` contents
- `docs/transcripts/` — optional; Claude Code transcripts if contract requires audit trail
- `deliverables/DELIVERY_CHECKLIST.md` — the pass/fail gate output

## Stack (varies by engagement)

- Note the client's actual stack in this file, not in a sibling file. Keep it visible.
- Include: language + runtime version, framework, deploy target, CI, test framework

## Conventions

- Commit messages: `scope: imperative verb ...` with the scope reflecting the client's taxonomy if they have one
- Feature branches, squash merge, no force pushes
- Document every external dependency in `NOTICE.md` with license
- Timestamps in Central Time unless the client specified otherwise

## What NOT to do

- Don't disclose AI use in commit messages, code comments, or README unless the client asked for it
- Don't leave any `TODO:` referring to internal Billington Works infrastructure
- Don't ship `.claude/` with global-scope settings or personal MCP servers
- Don't ship the AI Addendum PDF in the repo — link to the contract location instead
- Don't commit Brent's personal email or Halff email in author metadata; use the Billington Works address

## Last 5 lines — pre-delivery

- `HANDOFF.md` present and honest (including failed approaches)?
- Full-history secret scan clean?
- Brand audit clean (zero Halff, zero personal)?
- Delivery checklist at deliverables/DELIVERY_CHECKLIST.md all green?
- Addendum link present in README or contract, not embedded in repo?
