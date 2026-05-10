# Proposal 05 — Billington Works delivery bundle

| Field | Value |
|---|---|
| Target file(s) | `CLAUDE_CODE_STANDING_RULES.md` + new section; optional new `AGENTS_CLIENT_DELIVERY.md` |
| Change type | ADD (new section) + cross-link to new templates |
| Effort | M (mostly wiring together drafted templates) |
| Impact | **High** (direct commercial value for Billington Works) |
| Risk | Medium — legal language in AI addendum needs a lawyer review before reuse |
| Sources | `playbook/research/freelancer.md` (whole report), `playbook/synthesis/RECOMMENDATIONS.md` #5–8 |
| Dependencies | Proposals 01 (hooks), 02 (skills), 03 (projects) — but can ship independently |

---

## Rationale

CCC today is silent on how Brent structures Claude Code for client work. `freelancer.md` research is unambiguous:

1. Per-client CC profiles (via `claude-code-profiles`) prevent credential bleed.
2. `.claude/settings.json` committed per client repo with deny rules for secrets.
3. Fixed-fee or weekly retainer beats hourly.
4. Every deliverable ships with HANDOFF.md + generated README + `.claude/` config.
5. AI contract addendum: tool whitelist, no-training clause, human-review, IP assignment.
6. Template repo (`bw-project-template`) = moat.

This proposal bundles these into a coherent addition to standing rules. All the skills, agents, and CLAUDE.md templates already exist under `playbook/templates/`; this proposal is the orchestrating glue.

## Change — proposed new section

Add to `CLAUDE_CODE_STANDING_RULES.md` after § Active Projects (around line 243):

```markdown
---

## Billington Works — Client Delivery Protocol

### Per-client context isolation

- **Profile per active engagement.** Use `pegasusheavy/claude-code-profiles`. Name profiles `bw-<client>`. Each profile has its own settings, MCP servers, CLAUDE.md, and shell history. Switch before any work on that client's repo.
- **Committed `.claude/settings.json` per client repo.** Must include `permissions.deny` for: `Read(./.env*)`, `Read(./secrets/**)`, `Read(./*.pem)`, `Read(./*.key)`. Ship with the handoff.
- **Personal `~/.claude/settings.json`.** Global deny rules as belt-and-braces. Ruff hook, rm-rf guard, secret-scan hook attached globally.
- **Devcontainer for untrusted work.** Use `trailofbits/claude-code-devcontainer` (or equivalent) whenever a client repo is unfamiliar.

### Deliverable bundle

Every Billington Works engagement ships with:

- `HANDOFF.md` — goal, progress, what worked, what didn't (with reasons), next steps
- `README.md` — auto-generated, hand-edited "Ops" section
- `.claude/` — project-scoped only (never copy personal `~/.claude/` contents)
- `deliverables/DELIVERY_CHECKLIST.md` — output of the `client-deliverable-packager` agent
- Optional: `docs/transcripts/` — when contract requires audit trail

### Pricing defaults

- **Fixed-fee** or **weekly retainer** for any engagement with stable scope.
- **Hourly** only for discovery or open-ended consulting.
- Rationale: you capture the Claude Code productivity gain as margin.

### AI contract addendum (one page, reused across engagements)

Attached to every SOW:

- Tool whitelist: Claude Code, Cursor (optional), Copilot (optional)
- No-training warranty
- Human-in-the-loop clause (you review and validate AI output)
- IP assignment of your human contributions (selection, arrangement, edits)
- Disclosure & approval flow for any tool change
- Audit right (72h notification on out-of-scope tool use)

Draft with `zubair-trabzada/ai-legal-claude`, but have a lawyer review before reuse. Keep the signed PDF in `bw-contracts/` (private), not in client repos.

### Portfolio positioning

- Do NOT lead sales copy with "AI-built." Lead with outcome + stack + metrics.
- Do disclose specifically if asked: "Claude writes ~60% of boilerplate under my direction; I do architecture, review, testing."
- Track one public metric: average project turnaround. "Typical 5-page marketing site: 4 days."

### Template repo

Keep a private `bw-project-template` GitHub repo with pre-wired:

- `CLAUDE.md` from `projects/client-deliverable.CLAUDE.md`
- `.claude/settings.json` deny rules
- `scripts/bootstrap.sh` that copies `projects/<type>.CLAUDE.md` in
- `HANDOFF.md` scaffold
- `.gitignore` covering `.env*`, `secrets/**`, `output/`, `.cache/`

New engagement = `gh repo create --template bw-project-template <client>-<project>`.
```

## Anti-patterns honored

- A5 — devcontainer gate for YOLO-shaped work
- A15 — per-client CLAUDE.md enforced; global `~/.claude/CLAUDE.md` stays generic
- A18 — plugin vetting expected per profile

## Risks + mitigations

- **Legal language.** Draft via skill; have a lawyer review once; then reuse. Do not ship client-facing addenda generated from this proposal verbatim.
- **`claude-code-profiles` unknown license.** Confirm MIT/Apache before depending on it for production client work. Alternative: Brent can implement the profile switcher himself in ~50 lines of shell.

## Footer

- [ ] Approved by Brent
