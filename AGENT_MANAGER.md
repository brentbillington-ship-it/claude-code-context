# Agent Manager

> **Purpose:** Governs the lifecycle of all agent playbooks in this repo. Every CC session that modifies, creates, or retires an agent MUST update the registry below and follow the rules in this file.

---

## Registry

> **Scope:** This registry covers all active agents in CCC across three tiers:
> 1. **Core library** at `playbook/agents/<name>.md` — cross-project reusable agents (code review, research, data viz, doc writing, security, etc.). Sessions invoke these as-is OR augment them inline for task-specific needs. This is the first place a session looks when it needs an agent.
> 2. **Engagement-specific** at `agents/<name>.md` and `agents/<group>/<name>.md` — agents bound to a specific project/engagement (e.g., the family-office-tracker bundle for gala-holdings-tracker, or the universal senior-product-review quality gate).
> 3. **Project playbooks** at `AGENTS_*.md` (root) — Canvassing-Map-specific operational playbooks. Phase 4 will migrate these into Canvassing-Map's own `.claude/agents/`.

| Agent File | Status | Created | Last Updated | Scope | Retirement Trigger |
|---|---|---|---|---|---|
| `AGENTS_BROWSER_BOOTSTRAP.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | One-time Puppeteer + local harness setup for CC container | Project archived or replaced by CI pipeline |
| `AGENTS_VISUAL_QA.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Canvassing Map visual QA via Puppeteer (replaces PLAYWRIGHT_QA) | Project archived or replaced by CI pipeline |
| `AGENTS_COLOR_TRACE.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Marker color/shape/auto-set trace debugging | All color bugs resolved and stable for 2+ weeks |
| `AGENTS_DEPLOY_VERIFY.md` | **ACTIVE** | 2026-04-13 | 2026-04-13 | Post-push deploy verification | Project archived or replaced by CI pipeline |
| `AGENTS_PLAYWRIGHT_QA.md` | **RETIRED** | 2026-04-13 | 2026-04-13 | *(replaced by VISUAL_QA + BROWSER_BOOTSTRAP)* | — |
| `agents/senior-product-review.md` | **ACTIVE** | 2026-05-07 | 2026-05-19 | UIX + QA + research-gap reviewer for non-minor ships; cited in standing rules S1–S6 + V1-V5 | Permanent quality-gate agent — no time-boxed retirement |
| `agents/family-office-tracker/MANAGER.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Orchestrator for family-office tracker research run | Research deliverables accepted by Brent and v1 build complete |
| `agents/family-office-tracker/RESEARCH_METHODOLOGY_V2.md` | **ACTIVE** | 2026-05-06 | 2026-05-06 | Authoritative R1–R6 methodology shared by all family-office sub-agents (post-Vyzer-incident rebuild) | Same as MANAGER |
| `agents/family-office-tracker/PRICING.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker pricing & positioning research | Same as MANAGER |
| `agents/family-office-tracker/AESTHETICS.md` | **ACTIVE** | 2026-05-05 | 2026-05-19 | Family-office tracker UI/aesthetic competitor review; V1-V5 visual-review-discipline binding added | Same as MANAGER |
| `agents/family-office-tracker/DATAVIZ.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker data viz methodology | Same as MANAGER |
| `agents/family-office-tracker/FEATURES.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker feature competitive matrix | Same as MANAGER |
| `agents/family-office-tracker/FINANCE.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker finance methodology + spreadsheet audit | Same as MANAGER |
| `agents/family-office-tracker/SYNTHESIS.md` | **ACTIVE** | 2026-05-05 | 2026-05-06 | Family-office tracker research synthesis + style guide draft | Same as MANAGER |
| `agents/proposal-legal-review.md` | **ACTIVE** | 2026-05-15 | 2026-05-15 | Legal review of BW proposals vs executed NDA/MSA (IP/work-product overreach, missing carve-outs, governing-law, dispute language). Drafted for Gala Holdings v1 proposal review; reusable for any BW client | BW stops sending proposals |
| `agents/proposal-contract-manager.md` | **ACTIVE** | 2026-05-15 | 2026-05-15 | Buyer-eyes review and close-probability call; synthesizes the other three proposal lenses | BW stops sending proposals |
| `agents/proposal-pricing-qa.md` | **ACTIVE** | 2026-05-15 | 2026-05-15 | Pricing review of BW proposals (math, milestone economics, add-on ranges, competitive anchoring vs engagement research) | BW stops sending proposals |
| `agents/proposal-scope-qa.md` | **ACTIVE** | 2026-05-15 | 2026-05-15 | Scope QA of BW proposals: discovery + buyer-confirmation cross-reference; hard-boundary drift detection; ambiguity flagging | BW stops sending proposals |

### Core Agent Library — `playbook/agents/`

Cross-project reusable agents. **First place to look when a session needs an agent.** Invoke as-is, or read as the starting point and augment inline for task-specific needs. Curated 2026-05-10 against native overlap (see `_audit/NATIVE_OVERLAP_AUDIT.md`) — three files dropped because Anthropic-native commands cover the same scope.

**Use these native commands instead** (no library agent for these — sessions invoke directly):
- `/review` (and `/ultrareview` for deep multi-agent review) — replaces the dropped `code-reviewer`
- `/security-review` — replaces the dropped `security-scanner`
- `/simplify` — would have been `simplifier` (never created)
- (post-Superpowers install) `obra/superpowers:systematic-debugging` — would have been `debugger`
- (post-Superpowers install) `obra/superpowers:test-driven-development` — would have been `test-runner`

| Agent File | Status | Created | Last Updated | Scope | Retirement Trigger |
|---|---|---|---|---|---|
| `playbook/agents/apps-script-deploy.md` | **ACTIVE** | 2026-05-10 | 2026-05-10 | CLASP-driven Apps Script deploy with deployment-ID stability check (no browser editor per standing rules) | Brent stops shipping Apps Script |
| `playbook/agents/autolisp-reviewer.md` | **ACTIVE** | 2026-05-10 | 2026-05-10 | AutoLISP code review for AutoCAD-native automation (entity-manipulation safety, vl-catch-all, DCL accessibility) | Brent stops doing civil-eng AutoLISP work |
| `playbook/agents/browser-qa.md` | **ACTIVE** | 2026-04-22 | 2026-05-19 | Tool-agnostic browser visual+functional QA. REWRITE 2026-05-10 to drop Playwright-CLI lock-in. 2026-05-19 added V1-V5 visual-review-discipline binding (mandatory pixel observation, failure-mode-by-example, no probe-as-proof) | Web work tapers off |
| `playbook/agents/client-deliverable-packager.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Billington Works client deliverable packager (skill-gates + manifest + zip; never auto-sends) | BW deliverables stop |
| `playbook/agents/data-extractor.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Two-tier PDF + HTML extraction with schema validation, null-over-guess discipline | Curation review revisits |
| `playbook/agents/data-viz-reviewer.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Chart/dashboard correctness + clarity rubric (cross-links to engagement-specific `agents/family-office-tracker/DATAVIZ.md`) | Curation review revisits |
| `playbook/agents/deploy-verify.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Post-deploy smoke (version-string, sentinel render, endpoint probes, cache-bust). Renamed from `deploy-verify-generic` | Curation review revisits |
| `playbook/agents/doc-writer.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | README/HANDOFF/ADR generator. WRAPS Anthropic-native `/init` (CLAUDE.md generator), extending scope + Brent-tone | Curation review revisits |
| `playbook/agents/halff-brand-auditor.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Halff brand-compliance auditor; bidirectional Halff↔BW bleed check; PE seal integrity. References `playbook/templates/skills/halff-brand-compliance/SKILL.md` | Brent stops Halff work |
| `playbook/agents/leaflet-map-debugger.md` | **ACTIVE** | 2026-05-10 | 2026-05-10 | Runtime debugging for Leaflet apps (markers/tiles/layers/zoom/geocoder). Pairs with `maps-tooling-reviewer` (non-runtime) | Leaflet work tapers off |
| `playbook/agents/maps-tooling-reviewer.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Map app / regional-analysis / geo-pipeline review rubric | Curation review revisits |
| `playbook/agents/research-subagent.md` | **ACTIVE** | 2026-04-22 | 2026-05-10 | Generic research scout with fetch budget (≤15 fetches, ≤3,000-token report cap); follows Wave-1/Wave-2 pattern from `playbook/research/` | Curation review revisits |
| `playbook/agents/uix-flow-auditor.md` | **ACTIVE** | 2026-05-10 | 2026-05-19 | UIX flow completeness audit (empty/error/loading/mobile-first variants). Complementary to `senior-product-review` (S1-S6 senior pass). V1-V5 visual-review-discipline binding added 2026-05-19 | UI work tapers off |
| `playbook/agents/web-scraper.md` | **ACTIVE** | 2026-05-10 | 2026-05-10 | Multi-target scraper with robots.txt respect, retry/backoff, schema-validated output. References `playbook/templates/skills/scraping-pipeline-boilerplate/SKILL.md`. Pairs with `data-extractor` | Halff Municipal-Markets pipeline retired |


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
| 2026-05-10 | RENAME | playbook/templates/agents/ → playbook/agents/ | Reframed the 12 files as the **active core agent library** (was incorrectly framed as "templates not in scope" in the prior commit). Sessions are now told to invoke or augment these before drafting new agents. Curation review pending — proposal to land at `_audit/AGENT_LIBRARY_PROPOSAL.md`. |
| 2026-05-10 | AUDIT | (registry-wide) | Replaced scope note with three-tier explanation (core library / engagement / project playbooks). Added Core Library subsection registering all 12 files. Pre-commit hook globs extended to include `playbook/agents/` so future edits to the library enforce the registry update. Standing rules amended with "Agent Library Lookup Order" (5-tier search). |
| 2026-05-10 | RETIRE | playbook/agents/code-reviewer.md | Dropped per `_audit/NATIVE_OVERLAP_AUDIT.md` — Anthropic ships `/review` and `/ultrareview` natively. File deleted; sessions use the native commands. |
| 2026-05-10 | RETIRE | playbook/agents/security-scanner.md | Dropped per `_audit/NATIVE_OVERLAP_AUDIT.md` — Anthropic ships `/security-review` natively. File deleted; sessions use the native command. |
| 2026-05-10 | RETIRE | playbook/agents/checkpoint-keeper.md | Dropped per `_audit/AGENT_LIBRARY_PROPOSAL.md` — duplicates the harness Stop hook + auto-memory. Keeping a manual fallback invited bypassing the automation. |
| 2026-05-10 | RENAME | playbook/agents/deploy-verify-generic.md → deploy-verify.md | Dropped the `-generic` suffix (cross-project is the default; project-specific lives at `AGENTS_DEPLOY_VERIFY.md` for Canvassing-Map). Edits + YAML frontmatter added. |
| 2026-05-10 | REWRITE | playbook/agents/browser-qa-generic.md → browser-qa.md | Full rewrite per `_audit/C-browser-stack.md` corrections + `_validation/comparison.md` empirical findings. Drops Playwright-CLI lock-in (broken on Brent's Windows + Node stack), embraces "pick most efficient browser tool per task," documents @browser / Playwright MCP / Bash-subprocess decision tree, retires the "Puppeteer wrong by policy" framing. |
| 2026-05-10 | UPDATE | playbook/agents/{data-viz-reviewer,maps-tooling-reviewer,halff-brand-auditor,data-extractor,research-subagent,client-deliverable-packager,doc-writer}.md | Added YAML frontmatter (name, description, tools, model) so Claude Code's auto-router can delegate to them by description. Light edits to descriptions and skill-path references where needed. |
| 2026-05-10 | CREATE | playbook/agents/uix-flow-auditor.md | NEW. UIX flow completeness audit (empty/error/loading/mobile-first variants); per-flow checklist; complementary to senior-product-review S1-S6. |
| 2026-05-10 | CREATE | playbook/agents/leaflet-map-debugger.md | NEW. Runtime debugging for Leaflet apps; complements `maps-tooling-reviewer` (which handles non-runtime review). |
| 2026-05-10 | CREATE | playbook/agents/web-scraper.md | NEW. Multi-target scraper with robots.txt respect, retry/backoff, schema-validated output; pairs with `data-extractor`. |
| 2026-05-10 | CREATE | playbook/agents/apps-script-deploy.md | NEW. CLASP-driven Apps Script deploy with deployment-ID stability check; pairs with `deploy-verify`. |
| 2026-05-10 | CREATE | playbook/agents/autolisp-reviewer.md | NEW. AutoLISP code review for AutoCAD-native automation (`Sign_Routing` and civil-eng work); covers entity-manipulation safety, vl-catch-all error handling, DCL UI accessibility. |
| 2026-05-15 | CREATE | playbook/agents/proposal-{legal-reviewer,contract-mgmt,pricing-reviewer,scope-qa}.md | NEW. Reusable proposal-review bundle drafted during Gala Holdings v1 proposal review. Four agents cover legal / contract-completeness / pricing / scope-QA lenses. Each follows AGENT_MANAGER template + YAML frontmatter so Claude Code router can delegate by description. proposal-legal-reviewer is wired to reference `project_gala_ownership_clause.md` memory (canonical condensed Ownership-clause shape, architect analogy, no "framework", no three-clause carve-outs). |
| 2026-05-19 | UPDATE | (standing rules + 4 agents) | Added § Visual Review Discipline (V1-V5) to CLAUDE_CODE_STANDING_RULES.md. Cross-referenced + bound from `agents/senior-product-review.md`, `playbook/agents/uix-flow-auditor.md`, `playbook/agents/browser-qa.md`, `agents/family-office-tracker/AESTHETICS.md`. Triggered by BB-Notes v4.3 CodeMirror port: visual-review subagents marked broken-editor captures as PASS because dispatch prompts checked element-existence (`hasCM: true`) not visual intent. Editor shipped with raw markdown markers + black text on dark + no cursor. Brent caught it in 30 sec of actual use. V1 (pixel observation before deduction), V2 (failure-mode-by-example in prompts), V3 (no probe-as-proof), V4 (reference cross-check), V5 (mandatory readability/contrast check). Last Updated bumped on all 4 agents. |
| 2026-07-02 | AUDIT | (registry reconciliation) | Harness review found 4 phantom registry rows: the 2026-05-15 changelog entry logged the proposal agents at `playbook/agents/proposal-{legal-reviewer,contract-mgmt,pricing-reviewer,scope-qa}.md`, but the files were actually committed to `agents/` under the names `proposal-{legal-review,contract-manager,pricing-qa,scope-qa}.md`. Removed the 4 dead-path rows from the Core Library table; registered the 4 real files in the engagement-tier table. Root cause: the drift-guard pre-commit hook was inert (not executable, `core.hooksPath` unset), and it validates staging, not path existence. Both fixed this session. |
