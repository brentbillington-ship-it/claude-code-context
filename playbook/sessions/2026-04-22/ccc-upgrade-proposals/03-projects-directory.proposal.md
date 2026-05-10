# Proposal 03 — Populate `projects/` with 6 CLAUDE.md templates

| Field | Value |
|---|---|
| Target file(s) | `projects/` directory (currently empty) |
| Change type | ADD |
| Effort | S (already drafted) |
| Impact | **High** |
| Risk | Low |
| Sources | `playbook/research/freelancer.md` (3-tier CLAUDE.md), `playbook/research/github.md` (citypaul/ryoppippi), `playbook/synthesis/GAP_ANALYSIS.md` #3 |
| Dependencies | None |

---

## Rationale

CCC `README.md` promises per-repo CLAUDE.md templates under `projects/`. The directory is empty. Six templates drafted under `playbook/templates/claude-md/`, one per project archetype in Brent's stack:

1. `web-app.CLAUDE.md` — generic web app (Leaflet or React)
2. `campaign-tool.CLAUDE.md` — Canvassing / Signs Map family
3. `civil-eng-autolisp.CLAUDE.md` — Halff civil / AutoLISP
4. `scraping-pipeline.CLAUDE.md` — Municipal-Markets-style pipelines
5. `apps-script.CLAUDE.md` — Google Apps Script (CLASP workflow)
6. `client-deliverable.CLAUDE.md` — Billington Works client engagements

Every template:

- Stays under 200 lines (CCC rule)
- Puts build/run at the top
- Puts 5 critical rules in the first 5 lines after build/run
- Puts a 5-item pre-push / pre-delivery checklist in the last 5 lines
- Uses positive framing ("MUST use X") not negatives

## Change — proposed action

Move `playbook/templates/claude-md/*` → `projects/*`.

## Anti-patterns honored

- A3 — all templates under 200 lines, critical rules front-and-back
- A15 — `client-deliverable.CLAUDE.md` reinforces per-client isolation; no shared client CLAUDE.md

## Footer

- [ ] Approved by Brent
