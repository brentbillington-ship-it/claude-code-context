# Proposal 06 — Add 10 reusable agent templates to CCC

| Field | Value |
|---|---|
| Target file(s) | New top-level `.md` files in CCC root + `AGENT_MANAGER.md` registry update |
| Change type | ADD + MODIFY registry |
| Effort | L (10 files × 30 min each; already drafted) |
| Impact | Medium |
| Risk | Low |
| Sources | `playbook/research/github.md` (wshobson/agents), `playbook/synthesis/GAP_ANALYSIS.md` #4 |
| Dependencies | Existing `AGENT_MANAGER.md` template |

---

## Rationale

Current CCC has 4 active agents, all project-specific (Canvassing-Map / Halff). Missing: generic reusable agents that would apply across any project in Brent's stack. `wshobson/agents` ships 184; CCC needs ~10 of the most broadly useful.

Ten drafted under `playbook/templates/agents/`:

1. `code-reviewer.md` — pre-PR diff review
2. `research-subagent.md` — the generic scout pattern used by this very playbook run
3. `deploy-verify-generic.md` — generic post-deploy smoke test (GitHub Pages + Apps Script + generic)
4. `data-extractor.md` — structured extraction via Haiku + two-tier PDF rule
5. `browser-qa-generic.md` — Playwright viewport sweep
6. `security-scanner.md` — pre-push security sweep
7. `doc-writer.md` — README/HANDOFF/ADR generator
8. `checkpoint-keeper.md` — multi-day context continuity
9. `client-deliverable-packager.md` — Billington Works final-zip validator
10. `halff-brand-auditor.md` — Halff brand compliance audit

Every file follows the existing `AGENT_MANAGER.md` template structure (Purpose / When to Invoke / Prerequisites / Playbook / Success Criteria / Failure Modes / Output Artifacts).

## Change — proposed action

Copy each to CCC root as `AGENTS_<NAME>.md` (matching existing naming). Update `AGENT_MANAGER.md` registry table and changelog:

### Registry additions

```markdown
| `AGENTS_CODE_REVIEWER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Pre-PR diff review, critical-mindset | Retired when CI reviewer replaces it |
| `AGENTS_RESEARCH_SUBAGENT.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Generic research scout; 1.5–3k token reports | Retired when no research runs for 6 months |
| `AGENTS_DEPLOY_VERIFY_GENERIC.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Generic post-deploy smoke test | Supersedes `AGENTS_DEPLOY_VERIFY.md` once proven |
| `AGENTS_DATA_EXTRACTOR.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | PDF/HTML/image → structured rows | Retired when no extraction work for 6 months |
| `AGENTS_BROWSER_QA_GENERIC.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Generic Playwright viewport sweep | Supersedes `AGENTS_VISUAL_QA.md` once proven |
| `AGENTS_SECURITY_SCANNER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Pre-push security sweep (history-wide) | Retired when enterprise scanner replaces |
| `AGENTS_DOC_WRITER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | README/HANDOFF/ADR generator | Retired if repos stay doc-complete for 12 months |
| `AGENTS_CHECKPOINT_KEEPER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Multi-day context continuity | Retired when native checkpoint UX suffices |
| `AGENTS_CLIENT_DELIVERABLE_PACKAGER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Billington Works delivery validator | Retired when CI release pipeline replaces |
| `AGENTS_HALFF_BRAND_AUDITOR.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Halff brand compliance audit | Retired when Halff publishes automated brand CI |
```

### Changelog entry

```markdown
| 2026-04-22 | CREATE (bulk) | 10 AGENTS_*.md files | Playbook overnight sweep added generic reusable agents — see playbook/ccc-upgrade-proposals/06-agents-templates.proposal.md |
```

Note: `AGENTS_DEPLOY_VERIFY_GENERIC.md` and `AGENTS_BROWSER_QA_GENERIC.md` propose superseding the project-specific `AGENTS_DEPLOY_VERIFY.md` and `AGENTS_VISUAL_QA.md`. Keep both active until the generics are proven on a real release; then retire the specifics per the AGENT_MANAGER lifecycle rule.

## Anti-patterns honored

- A10 — no nested-subagent patterns; every agent is a leaf
- A13 — every new agent has a concrete retirement trigger

## Footer

- [ ] Approved by Brent
