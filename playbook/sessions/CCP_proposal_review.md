# CCP: Proposal Pre-Send Review

> **Run a 4-agent parallel review of a drafted client proposal before send. Produces scope-QA, pricing-QA, legal-review, and contract-manager findings, then synthesizes into a single go/no-go review.**

> Created 2026-05-15 for the Gala Holdings tracker proposal. Generalizable to any future Billington Works proposal review.

---

## CRITICAL: Fill in before running

Replace the bracketed values below with actual paths for this run:

```
PROJECT_REPO       = [e.g., gala-holdings-tracker]
PROPOSAL_PDF       = [e.g., /path/to/Billington_Works_Gala_Proposal.pdf]
NDA_PDF            = [e.g., /path/to/GALA_Mutual_NDA__BB_SIGNED_.pdf]
SCOPE_SOURCE       = [e.g., gala-holdings-tracker/STATE_OF_THINGS.md]
PRICING_RESEARCH   = [e.g., gala-holdings-tracker/research/06_pricing_positioning.md]
DISCOVERY_DOCS     = [e.g., gala-holdings-tracker/2026-05-05 - Gala Holdings Tracking Tool - Scoping Meeting.docx]
BUYER_PROFILE      = [pull from PROJECT_REPO/STATE_OF_THINGS.md "Stakeholder map" section]
```

---

## Step 1 — Load standing context

Read in order:

1. `claude-code-context/CLAUDE_CODE_STANDING_RULES.md` — the General MD. Surgical edits, no destructive changes, Central Time timestamps, etc.
2. `claude-code-context/agents/proposal-scope-qa.md`
3. `claude-code-context/agents/proposal-pricing-qa.md`
4. `claude-code-context/agents/proposal-legal-review.md`
5. `claude-code-context/agents/proposal-contract-manager.md`

These four agents are the reviewers. Read each one's playbook section so the dispatch is faithful to the agent spec.

## Step 2 — Load source material

Read in order:

1. `SCOPE_SOURCE` (e.g., `gala-holdings-tracker/STATE_OF_THINGS.md`) — canonical scope reference.
2. `PRICING_RESEARCH` (e.g., `gala-holdings-tracker/research/06_pricing_positioning.md`) — pricing research deliverable.
3. `DISCOVERY_DOCS` — discovery meeting recap and any post-meeting client confirmation (especially the Aaron 5/5 email).
4. `NDA_PDF` — executed confidentiality agreement.
5. `PROPOSAL_PDF` — the drafted proposal under review.
6. Relevant `BB-Notes` content for posture context: read `BB-Notes/CONTEXT.md` and any `threads/` files matching the active engagement. Do NOT pull in unrelated career content (Halff, F&N, Leigh, Ryan).

## Step 3 — Dispatch four reviewers in parallel

Spawn four fresh general-purpose subagents in parallel, one per agent file. Each subagent gets:

1. Its agent definition file (the relevant `agents/proposal-*.md`)
2. The standing rules (CCC's General MD)
3. The full proposal PDF
4. The relevant source documents per their playbook
5. The buyer profile

**The implementer (you, the dispatching agent) does NOT generate findings.** Per CCC S3 — no grading own work. Your role here is dispatch, validation of output format, and synthesis.

Track which agent gets which inputs:

| Agent | Inputs |
|---|---|
| **scope-qa** | Standing rules, agent spec, `SCOPE_SOURCE`, `DISCOVERY_DOCS`, `PROPOSAL_PDF` |
| **pricing-qa** | Standing rules, agent spec, `PRICING_RESEARCH`, `BB-Notes` pricing posture, `PROPOSAL_PDF` |
| **legal-review** | Standing rules, agent spec, `NDA_PDF`, `PROPOSAL_PDF`, `SCOPE_SOURCE` (for cross-check) |
| **contract-manager** | Standing rules, agent spec, `PROPOSAL_PDF`, `BUYER_PROFILE`, `BB-Notes` posture, **outputs from the other 3 agents** (so this runs last or in a second phase) |

The contract-manager agent reads the other three agents' outputs in step 11 of its playbook. So in practice:
- **Phase 1 parallel**: scope-qa, pricing-qa, legal-review
- **Phase 2 single**: contract-manager (after the three Phase 1 agents complete)

## Step 4 — Validate each agent's output

For each agent's output, verify:

1. **File exists** at the path specified in its playbook (e.g., `PROJECT_REPO/research/proposal-scope-qa.md`)
2. **Required sections present** per its playbook output structure
3. **Findings are severity-tagged** (critical / major / minor / cosmetic)
4. **Citations are specific** — quoted text and section references, not vague summaries
5. **No invented sources** — every claim traces to one of the documents in step 2
6. **No BB-Notes leakage** — no Halff / F&N / Leigh / Ryan content
7. **No real client portfolio data** in any deliverable

If any check fails, re-spawn the agent with a sharper prompt referencing the specific failure.

## Step 5 — Synthesize

Write a single synthesis at `PROJECT_REPO/research/proposal-review-synthesis.md`:

```
# Proposal Pre-Send Review — <project> v<N>

*Synthesized: YYYY-MM-DD CT. Reviewers: scope-qa, pricing-qa, legal-review, contract-manager.*

## Verdict
- Overall: send as-is / send with fixes / rewrite
- Predicted client response (sign / redline / push price / scope expansion / defer)

## Critical items — must fix before send
| # | Reviewer | Finding | Recommended fix |

## Major items — strongly consider fixing before send
| # | Reviewer | Finding | Recommended fix |

## Reviewer consensus
Findings that 2+ reviewers raised independently — these are the strongest signals.

## Reviewer disagreement
Where reviewers' recommendations conflict, and which is the better call given the project context.

## Top N edits, in order of effort-to-impact
| # | Edit | Effort | Impact | Source reviewer |

## Items NOT to act on
Findings that surfaced but should be ignored, with reasoning. (E.g., a legal-review flag that's actually services-agreement territory, not proposal.)

## Items requiring Brent's decision before edits
- E.g., verify Claude account training setting is actually OFF (claim in proposal)
- E.g., confirm pricing JJ-anchor branch the proposal assumes
- E.g., any verification-required claim
```

## Step 6 — Mobile push summary

Send Brent a mobile push notification (per CCC standing rule on long-running tasks) with:

- Verdict (send / fix / rewrite)
- Count of critical / major / minor / cosmetic findings
- Top 3 items to fix
- Estimated rework time

## Step 7 — Do NOT commit or modify the proposal

Per CCC hard rules: no code changes, no file edits, no commits without explicit "go" from Brent. This CCP produces review documents only. Brent decides what to do with them.

---

## Reusing this CCP for future proposals

This is a reusable pattern. To use on a future engagement:

1. Copy this file to a new session
2. Update the `FILL IN` block at the top
3. Confirm the four agents in `claude-code-context/agents/proposal-*.md` are still current; update if the proposal genre has shifted (e.g., a productized SaaS proposal needs different lenses than a custom-build proposal)
4. Confirm the project repo has the prerequisites (scope source, pricing research, executed NDA, discovery recap)
5. Run

If a future project doesn't have a pricing research deliverable (e.g., a small fixed-fee engagement where pricing didn't go through the full PRICING agent), drop the pricing-qa lens or replace it with a lighter "pricing sanity check" pass.

---

## Notes for the Gala Holdings run (2026-05-15)

For the immediate Gala run, fill in:

```
PROJECT_REPO       = gala-holdings-tracker
PROPOSAL_PDF       = (latest version Brent built — confirm path before running)
NDA_PDF            = GALA_Mutual_NDA__BB_SIGNED_.pdf (executed 5/13/2026)
SCOPE_SOURCE       = gala-holdings-tracker/STATE_OF_THINGS.md
PRICING_RESEARCH   = gala-holdings-tracker/research/06_pricing_positioning.md (verify path — may be `_v2.md`)
DISCOVERY_DOCS     = gala-holdings-tracker/2026-05-05 - Gala Holdings Tracking Tool - Scoping Meeting.docx (note: this file may be corrupt in the repo — Brent has the original locally)
BUYER_PROFILE      = Aaron Raynish — Texas Bar attorney (active 2002), CEO of family office, day-to-day operator, the buyer. Cares about: usability for himself and JJ, math correctness, scope discipline. Hard boundary set 5/5: "investment system first, not ERP."
```

Specific things to flag for this engagement:

- The proposal contains a `Notes` section with "Ownership" and "Development tools" clauses that explicitly address NDA section (v). The legal-review agent should verify these are sufficient.
- The pricing in the proposal should match the JJ-anchor branch decision the PRICING agent recommended; the contract-manager agent should verify the proposed price still makes sense given Brent's read on Aaron from the discovery meeting.
- The scope-qa agent should pay special attention to Aaron's 5/5 email additions (document storage, alerts/workflow) — both should appear in the proposal's Core Platform section.
