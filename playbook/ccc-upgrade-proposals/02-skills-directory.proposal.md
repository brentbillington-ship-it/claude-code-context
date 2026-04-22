# Proposal 02 — Populate `skills/` with 6 SKILL.md scaffolds

| Field | Value |
|---|---|
| Target file(s) | `skills/` directory (currently empty) |
| Change type | ADD |
| Effort | M (already drafted; 10 min to move) |
| Impact | **High** |
| Risk | Low |
| Sources | `playbook/research/anthropic.md` (skills guide), `playbook/research/practitioners.md` (Thariq), `playbook/synthesis/PATTERNS.md` #12 |
| Dependencies | None |

---

## Rationale

CCC `README.md` promises shared skills under `skills/`. The directory is empty. Anthropic now explicitly recommends skills over commands. Every one of Brent's stacks benefits from a targeted skill scaffold.

Six skills drafted under `playbook/templates/skills/`:

1. `civil-eng-qto-helper/` — QTO for Halff civil work, pairs with autocad-mcp
2. `campaign-data-processor/` — voter file → Canvassing-Map pipeline
3. `halff-brand-compliance/` — Halff brand + zero-Billington-Works-bleed audit
4. `scraping-pipeline-boilerplate/` — Municipal-Markets-style scraper scaffold
5. `bw-client-deliverable/` — Billington Works client handoff packaging
6. `apps-script-deployer/` — CLASP workflow wrapped as a skill

Every SKILL.md uses Anthropic's exact frontmatter conventions (PATTERNS.md #12): WHEN + WHEN-NOT descriptions, `disable-model-invocation: true` on side-effecting ones, `allowed-tools` pre-approvals.

## Change — proposed action

Move `playbook/templates/skills/<name>/` → `skills/<name>/` for all 6.

No standing rules change strictly required. Optional: add a one-line table to `CLAUDE_CODE_STANDING_RULES.md` § Custom Skills:

### Before (line 110)

```markdown
Skill files live in `skills/` in this repo. Reference them at session start or copy into `.claude/skills/` in a project.
```

### After (add table)

```markdown
Skill files live in `skills/` in this repo. Reference them at session start or copy into `.claude/skills/` in a project.

| Skill | When to invoke |
|---|---|
| `civil-eng-qto-helper` | Civil 3D / AutoCAD QTO computations |
| `campaign-data-processor` | Voter file filtering, geocoding, canvassing output |
| `halff-brand-compliance` | Halff deliverable brand audit |
| `scraping-pipeline-boilerplate` | New Playwright scraper scaffold |
| `bw-client-deliverable` | Billington Works client handoff packaging |
| `apps-script-deployer` | CLASP deploy of Google Apps Script projects |
```

## Anti-patterns honored

- A3 — every SKILL.md body stays well under 500 lines
- A14 — side-effecting skills (`bw-client-deliverable`, `apps-script-deployer`) set `disable-model-invocation: true`

## Footer

- [ ] Approved by Brent
