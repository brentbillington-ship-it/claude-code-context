# CCP: CCC Harness Audit & Forward-Practices Review

> **Run an Opus-4.8 + ultracode audit of the CCC harness itself: find obsolete / contradictory / missing items, research current (mid-2026) best practices, and produce a prioritized punch list. Proposals only until an explicit apply gate — no edits to CCC content until "go."**

> Created 2026-06-26 during the BB-Notes editor-hardening session. Generalizable to any future harness-drift audit (re-run whenever the model lineup or tool surface shifts).

**Repo under study:** `brentbillington-ship-it/claude-code-context` (CCC) — this repo reviews itself.
**Baseline rules:** `CLAUDE_CODE_STANDING_RULES.md` (the file under review).

---

## CRITICAL: confirm before running

```
MODEL    = claude-opus-4-8         # set for the session, not just the kickoff turn
MODE     = ultracode ON            # Workflow-driven; fan out; token cost not a constraint
BRANCH   = per system rule (a claude/* dev branch), NOT main
NPROC    = run `nproc` first       # 4 cores → Workflow cap is 2-wide; size fan-outs accordingly
```

---

## Execution directives (read before starting)

- **Review discipline:** the **AV1–AV5** rules added to standing rules on 2026-06-26 are themselves IN SCOPE for this audit — do not treat them as settled. But DO apply them to this session's own findings: every audit finding and every "best practice" claim goes through refute-by-default adversarial verify (AV1) before it reaches a deliverable.
- **Concurrency (AV4):** on a 4-core box the Workflow cap is 2-wide. Batch findings per verifier, dedup before fan-out, pipeline-don't-barrier when synthesis doesn't need the whole set at once.
- **The auditor does not grade its own findings (AV5 + S3):** lens agents find, separate verifiers refute, a synthesist decides. The session controller does not also author the findings it synthesizes.

---

## Objective

Decide, on evidence, what in CCC is **obsolete, contradictory, or missing**, and which **current (mid-2026) best practices** should be adopted — so Brent's harness gets sharper rather than accreting drift. The harness has visibly moved since the 2026-04-22 optimization session (the Workflow tool, skills, the remote-container execution model, the current Claude model lineup), and CCC carries assumptions from before that move.

Deliverable is a **prioritized punch list** split into:
1. **apply-now** — mechanical, uncontroversial fixes (dead refs, repo-name drift, version bumps)
2. **needs-Brent-decision** — judgment calls that change how the harness behaves
3. **research-more** — anything not verifiable to primary-source confidence this session

**Build nothing into the live harness until the Phase 4 apply gate.**

---

## Guardrails

- **Read-only against CCC content until the apply gate.** The audit produces proposals; it does not edit standing rules, agents, or playbooks until explicit "go." (Drafting the *deliverables* is fine — they live outside CCC until committed.)
- **Verify every "best practice" claim at runtime.** Do NOT trust training-data memory on tool versions, model names, plugin states, or API behavior — the knowledge cutoff predates the current state. Primary sources only (vendor docs, official repos), rendered/fetched at run time. The May 2026 Gala failure (invented Vyzer pricing tier) is the cautionary tale; R1–R6 apply to any visual claim, AV1–AV5 to every claim.
- **The auditor does not grade its own findings.** Per AV5 + S3: lens agents find, separate verifiers refute, a synthesist decides.
- **No secrets in deliverables** — reference any credential by env var / file location.
- **No destructive changes.** Retiring a rule or agent requires separate explicit approval (it is a delete).
- **Honor the existing structure.** Propose changes as diffs against the current CCC layout (`playbook/synthesis/`, `playbook/agents/`, `agents/`, `skills/`, root `*.md`). Don't reorganize wholesale without a Brent decision.
- **Agent-file governance still binds.** If any proposal touches `agents/**`, `playbook/agents/**`, or `AGENTS_*.md`, the AGENT_MANAGER.md update + `.githooks` rule applies — note it, don't bypass it silently.

---

## Phase 0 — Inherit state & inventory

- Confirm environment: model is `claude-opus-4-8`, ultracode on, `nproc`, `git status` clean, branch correct.
- Read `CLAUDE_CODE_STANDING_RULES.md` in FULL (it is ~800 lines now; the sandbox section, research methodology, debugging discipline, senior review, and the AV section all matter).
- Read the **existing** synthesis from the 2026-04-22 session: `playbook/synthesis/{ANTI_PATTERNS,RECOMMENDATIONS,PATTERNS,GAP_ANALYSIS}.md` and `playbook/sessions/2026-04-22/`. **Establish what was already proposed and whether it landed** — do not re-discover known findings as if new.
- Map the full CCC tree: every `*.md` under root, `agents/`, `playbook/**`, `skills/`, `hooks/`, `.githooks/`, `projects/`. Count files, note last-modified, flag anything obviously orphaned.

Deliver a short state note: tree shape, what the prior session already fixed vs. proposed-but-unlanded, confirmed environment.
**Stop. Wait for go.**

## Phase 1 — Obsolescence audit  *(what's stale)*

Fan out across CCC (lens agents, each adversarially verified per AV1) for:

- **Stale model references.** Model routing is pinned to "Sonnet 4.6 daily / Opus 4.7 architecture / Haiku 4.5 mechanical" (`playbook/synthesis/PATTERNS.md`, `playbook/EXPORT/README_FOR_IMPORT.md`); ANTI_PATTERNS A4 cites "Opus 4.7 burns 1.5–3× more than 4.6." Opus 4.8 and Fable 5 now exist. Catalog every model-version-specific claim.
- **Pinned tool versions.** `Superpowers v5.0.7` is hard-coded across catalogs, MCP tables, standing rules. Verify current version + whether the pin still holds.
- **Superseded patterns.** (a) The **Brainstorm mandate** — Prime Directive says "MUST invoke Brainstorm before touching any code," but Brainstorm isn't shipped in CCC (`GAP_ANALYSIS #8`) and the current harness leans on the Workflow tool + skills instead. Is the mandate obsolete, or should Brainstorm be vendored? (b) **Chrome MCP fallback** for GitHub writes — `github-mcp-server` works directly now (the 2026-06-25 session confirmed `api.github.com` reachable in-container, contradicting the "api.github.com blocked" assumption several docs carry). (c) **PowerShell / Windows notification** patterns — sessions now run in remote Linux containers.
- **Repo-name drift.** Standing rules Active Projects table + several agent descriptions say `Municipal-Markets`; the real repo is `municipal-market-research`. Find every instance.
- **Broken cross-refs + internal contradictions.** Docs that reference files / skills / agents that don't exist; rules that contradict each other across documents.
- **Disproven assumptions.** Anything stated as fact that recent execution contradicted (the egress / proxy model, the push path, the container OS).

Produce an **obsolescence table**: item → location(s) → why stale → confidence (verified / likely / uncertain) → suggested disposition (fix / retire / leave).
**Stop. Wait for go.**

## Phase 2 — Forward best-practices research  *(what to add)*

Research **current** (mid-2026, verify at run time) best practices, each claim tied to a primary source and adversarially verified:

- **Claude Code harness design & context engineering** — CLAUDE.md structure, the first-5 / last-5-lines attention rule, skills vs. agents vs. slash commands, settings / hooks hygiene.
- **Multi-agent orchestration** — the Workflow tool patterns (pipeline vs. parallel, adversarial verify, loop-until-dry, judge panels); when orchestration beats a single context; the cost / quality frontier.
- **Model routing for the current lineup** — Opus 4.8 / Sonnet 4.6 / Haiku 4.5 / Fable 5: where each wins, the opusplan pattern's current economics, fast-mode. Replace the 4.7-era routing math.
- **MCP server hygiene** — the ~20k-token budget rule, deferred / searchable tools, which servers earn their context.
- **Memory & session continuity** — cross-session memory options, the context-compaction thresholds, what survives a compact.
- **Cross-model vs. same-model review** — reconcile the genuine tension: ANTI_PATTERNS A6 says "never let the same model review its own code; reviewer must be a *different* model," but the new AV1–AV5 prescribes *same-model* refute-by-default adversarial verify. Which holds, when? Is adversarial framing a sufficient substitute for model diversity, or a complement? This is the single most important reconciliation in the audit — treat it as a first-class research question, not a footnote.

Produce a **forward-practices brief**: practice → primary source → does CCC already do this? → adopt / adapt / skip.
**Stop. Wait for go.**

## Phase 3 — Harness-gap synthesis

Cross Phase 1 (stale) against Phase 2 (forward). Produce a **gap matrix**:
- Where is CCC **behind** current practice (adopt)?
- Where is CCC **ahead** or deliberately different (keep, and document why)?
- Where do internal rules **genuinely conflict** (A6 vs the AV section is the headline; resolve it with a stated rule, not a vibe)?

Flag the **three-strikes** signal (per S4's spirit): if more than a few load-bearing rules turn out obsolete, treat the standing-rules baseline as due for a structural refresh, not just line edits — and say so.
**Stop. Wait for go.**

## Phase 4 — Prioritized punch list + apply gate

Split every recommendation:
1. **apply-now** — mechanical / uncontroversial (repo-name fixes, dead-ref removal, version bumps, model-routing number refresh). Prepare the diffs; do NOT commit until "go."
2. **needs-Brent-decision** — judgment calls (retire the Brainstorm mandate? adopt cross-model review and how? vendor Brainstorm? restructure standing rules?). Frame each as a crisp question with a recommendation.
3. **research-more** — anything unverifiable to primary-source confidence this session.

**Stop. Wait for go on the apply-now diffs specifically** (separate from the "go" that advanced phases).

## Phase 5 — Deliverables

1. `ccc-current-state.md` — Phase 0 inventory + Phase 1 obsolescence table.
2. `forward-practices.md` — Phase 2 brief, every external claim cited to a primary source.
3. `harness-gap-matrix.md` — Phase 3 synthesis, including the A6-vs-AV reconciliation.
4. `recommendation.md` — the prioritized punch list + the apply gate.

Commit to CCC only on separate explicit go. Natural home: `playbook/sessions/2026-06-26/` (matches the existing session-archive convention) with the punch-list proposals alongside. CT timestamps. If any agent file is touched, AGENT_MANAGER.md updates in the same commit.

---

## Note (reusability, light)

"Audit your own AI harness for drift" is itself a repeatable methodology — any shop running a context-engineering harness (CLAUDE.md + agents + skills + hooks) accrues the same obsolescence debt every time the underlying models and tools move. If a clean, repeatable harness-audit checklist falls out of this (especially the model-routing-refresh and the cross-model-vs-adversarial-verify reconciliation), flag it for the BW methodology library. Don't overbuild the audit to chase it.
