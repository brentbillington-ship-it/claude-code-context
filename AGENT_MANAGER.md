# Agent Manager

> **Purpose:** Governs the lifecycle of all agent playbooks in this repo. Every CC session that modifies, creates, or retires an agent MUST update the registry below and follow the rules in this file.

---

## Registry

> **Scope:** This registry covers `AGENTS_*.md` at repo root and `agents/**/*.md`. Files under `playbook/templates/agents/` are exports for other repos to copy from, not active CCC agents.

| Agent File | Status | Created | Last Updated | Scope | Retirement Trigger |
|---|---|---|---|---|---|
| `AGENTS_BROWSER_BOOTSTRAP.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | One-time Puppeteer + local harness setup for CC container | Project archived or replaced by CI pipeline |
| `AGENTS_VISUAL_QA.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Canvassing Map visual QA via Puppeteer (replaces PLAYWRIGHT_QA) | Project archived or replaced by CI pipeline |
| `AGENTS_COLOR_TRACE.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Marker color/shape/auto-set trace debugging | All color bugs resolved and stable for 2+ weeks |
| `AGENTS_DEPLOY_VERIFY.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Post-push deploy verification | Project archived or replaced by CI pipeline |
| `AGENTS_PLAYWRIGHT_QA.md` | **RETIRED** | 2026-04-13 | 2026-04-13 | *(replaced by VISUAL_QA + BROWSER_BOOTSTRAP)* | — |
| `agents/senior-product-review.md` | **ACTIVE** | 2026-05-07 | 2026-05-09 | UIX + QA + research-gap reviewer for non-minor ships; cited in standing rules S1–S6 | Permanent quality-gate agent — no time-boxed retirement |
| `agents/family-office-tracker/MANAGER.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Orchestrator for family-office tracker research run | Research deliverables accepted by Brent and v1 build complete |
| `agents/family-office-tracker/RESEARCH_METHODOLOGY_V2.md` | **ACTIVE** | 2026-05-06 | 2026-05-06 | Authoritative R1–R6 methodology shared by all family-office sub-agents (post-Vyzer-incident rebuild) | Same as MANAGER |
| `agents/family-office-tracker/PRICING.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker pricing & positioning research | Same as MANAGER |
| `agents/family-office-tracker/AESTHETICS.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker UI/aesthetic competitor review | Same as MANAGER |
| `agents/family-office-tracker/DATAVIZ.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker data viz methodology | Same as MANAGER |
| `agents/family-office-tracker/FEATURES.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker feature competitive matrix | Same as MANAGER |
| `agents/family-office-tracker/FINANCE.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker finance methodology + spreadsheet audit | Same as MANAGER |
| `agents/family-office-tracker/SYNTHESIS.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker research synthesis + style guide draft | Same as MANAGER |

### Status Values
- **ACTIVE** — Available for invocation in any CC session.
- **DORMANT** — Not currently needed but may return. Keep file, skip in default runs.
- **RETIRED** — Delete the file. Remove from registry. Note reason in the changelog below.
- **DRAFT** — Under development. Do not invoke in production sessions.

---

## Lifecycle Rules

### Creating an Agent
1. Write the `.md` file following the template structure (see below).
2. Add a row to the Registry table above with status `ACTIVE` or `DRAFT`.
3. Set a concrete **Retirement Trigger** — no open-ended agents.
4. Log in the Changelog.

### Updating an Agent
1. Edit the agent file.
2. Update `Last Updated` in the registry.
3. Log the change with a one-line summary in the Changelog.

### Merging Agents
When two agents overlap >50% in scope:
1. Create the merged agent file.
2. Set both originals to `RETIRED`.
3. Add the merged agent to the registry.
4. Log in Changelog with merge rationale.

### Retiring an Agent
1. Check the Retirement Trigger — if met, proceed.
2. Delete the agent `.md` file from the repo.
3. Update status to `RETIRED` in the registry.
4. Log reason in Changelog.
5. Remove any references from `CLAUDE_CODE_STANDING_RULES.md`.

### Dormant Transition
If an agent hasn't been invoked in 4+ weeks but its retirement trigger isn't met:
1. Set status to `DORMANT`.
2. CC sessions skip it unless explicitly requested.

---

## Agent File Template

```markdown
# Agent Name

> **One-line purpose**

## When to Invoke
- Bullet list of triggers (what prompt or situation activates this agent)

## Prerequisites
- Tools, packages, env vars needed

## Playbook
Step-by-step instructions CC follows. Numbered. Concrete.

## Success Criteria
- What "done" looks like. Measurable.

## Failure Modes & Recovery
- Known failure → specific fix

## Output Artifacts
- What files/logs this agent produces and where they go
```

---

## Invocation Convention

In any CC prompt, reference agents by filename:

```
Invoke AGENTS_PLAYWRIGHT_QA.md — run full visual QA against live site.
```

CC reads the file, follows the playbook, reports against the success criteria.

To invoke the manager itself:

```
Invoke AGENT_MANAGER.md — [action: create|update|merge|retire|audit] [target agent(s)]
```

### Audit Action
When invoked with `audit`, the manager:
1. Lists all agent files in the repo.
2. Checks each against the registry (orphan detection).
3. Checks `Last Updated` — flags anything >4 weeks as dormant candidate.
4. Checks retirement triggers — flags any that are met.
5. Reports findings. Takes no action without explicit "go."

---

## Changelog

| Date | Action | Agent(s) | Summary |
|---|---|---|---|
| 2026-04-13 | CREATE | AGENTS_BROWSER_BOOTSTRAP.md | Puppeteer + local harness setup for CC container (solves CDN/network blocks) |
| 2026-04-13 | CREATE | AGENTS_VISUAL_QA.md | Visual QA rewritten for Puppeteer + local harness |
| 2026-04-13 | RETIRE | AGENTS_PLAYWRIGHT_QA.md | Replaced by BROWSER_BOOTSTRAP + VISUAL_QA (Playwright CDN blocked in CC) |
| 2026-04-13 | CREATE | AGENTS_COLOR_TRACE.md | Marker color/shape debugging trace |
| 2026-04-13 | CREATE | AGENTS_DEPLOY_VERIFY.md | Post-push deploy smoke test |
| 2026-04-13 | CREATE | AGENT_MANAGER.md | Meta-agent for lifecycle governance |
| 2026-05-05 | CREATE | agents/family-office-tracker/* (7 agents) | Research orchestrator + 5 sub-agents + synthesis for Gala Holdings Tracker engagement; reusable pattern for future family-office work |
| 2026-05-06 | CREATE | agents/family-office-tracker/RESEARCH_METHODOLOGY_V2.md | Authoritative R1–R6 methodology rebuilt post-Vyzer-incident; governs the seven sub-agents above. Back-filled into registry on 2026-05-10 (Phase 3 audit cleanup). |
| 2026-05-06 | UPDATE | agents/family-office-tracker/* (7 agents) | Bulk rewrite to align with V2 methodology. Last Updated bumped from 2026-05-05 to 2026-05-06 retroactively (Phase 3 audit cleanup). |
| 2026-05-07 | CREATE | agents/senior-product-review.md | Permanent quality-gate agent (UIX + QA + research-gap review); wired into standing rules S1–S6. Back-filled into registry on 2026-05-10. |
| 2026-05-07 | UPDATE | agents/senior-product-review.md | UIX-lens addition: empty-state create-path is mandatory. (Back-fill summary; Last Updated 2026-05-09.) |
| 2026-05-09 | UPDATE | agents/senior-product-review.md | UIX-lens addition: feature-depth-comparison mandatory. |
| 2026-05-10 | AUDIT | (registry-wide) | Phase 3 audit back-fill: scope note added; senior-product-review and RESEARCH_METHODOLOGY_V2 added; family-office Last Updated bumped to 2026-05-06. Pre-commit drift hook installed under `.githooks/pre-commit`; standing rules amended to point at AGENT_MANAGER.md. |
| 2026-05-10 | UPDATE | agents/family-office-tracker/DATAVIZ.md | Added "see also" cross-link to `playbook/templates/agents/data-viz-reviewer.md` (per audit §3 dup-playbook resolution). |
| 2026-05-10 | UPDATE | AGENTS_DEPLOY_VERIFY.md | Fixed stale pointer: replaced `AGENTS_PLAYWRIGHT_QA.md` reference with `AGENTS_VISUAL_QA.md` (PLAYWRIGHT_QA was retired 2026-04-13). |
