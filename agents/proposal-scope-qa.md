# Proposal Scope QA Agent

> **Verify the proposal captures every confirmed scope item from discovery and the client's follow-up confirmation, with no drift or invented content. Source-of-truth check, line by line.**

> Created 2026-05-15 for the Gala Holdings tracker proposal review. Generalizable to any client proposal where discovery notes and a written scope confirmation exist.

## When to Invoke

- A drafted proposal exists and is being readied for client send
- A re-scoped or v2 proposal is being prepared after client feedback
- A proposal is being audited mid-engagement against the original scope of work

## When NOT to Invoke

- Brainstorm / draft phase (use scope ideation, not QA)
- Scope is still being negotiated verbally and no written confirmation exists
- Pure typo / formatting passes

## Prerequisites

- Drafted proposal accessible (PDF or markdown form)
- Discovery recap document (`.docx` or markdown)
- Client follow-up confirmation email (or equivalent) where they validated scope and set boundaries
- Project repo's STATE_OF_THINGS.md or equivalent canonical scope file
- For Gala specifically: `gala-holdings-tracker/STATE_OF_THINGS.md` and the 5/5 Aaron email reconfirmation

## Methodology

This is a **source-to-proposal traceability** check, not a creativity exercise. The agent maps:

1. Every confirmed scope item in source documents → did it land in the proposal?
2. Every proposal scope item → does it trace to a source document?
3. Every client-imposed boundary (e.g., "investment system, not ERP") → is it honored in scope and language?

Findings are tagged **critical / major / minor / cosmetic**:

- **Critical**: Confirmed scope item is missing from proposal, OR proposal includes scope the client didn't ask for, OR a client-imposed hard boundary is violated.
- **Major**: Scope item present but with materially different framing than discovery (e.g., narrower or broader).
- **Minor**: Naming inconsistency, description doesn't match discovery language well, ordering doesn't reflect client priority.
- **Cosmetic**: Phrasing / terminology preferences.

## How to Dispatch

Dispatched as a fresh general-purpose subagent. The proposer (Brent) does NOT generate findings themselves. The agent reads inputs cold and produces a structured report.

## Playbook

1. Read **CLAUDE_CODE_STANDING_RULES.md** in CCC.
2. Read the canonical scope source: `gala-holdings-tracker/STATE_OF_THINGS.md` (or equivalent project file).
3. Read the discovery recap document and any client confirmation emails captured in the project repo.
4. Read the proposal PDF cover-to-cover. Extract every scoped item, terms statement, and exclusion.
5. Build a **two-column traceability table**:

   | Source item | Proposal location | Status |
   |---|---|---|
   | (e.g., "Investment tracking — one record per deal..." from STATE_OF_THINGS) | Page 2, Core Platform row 1 | ✅ Present, faithful |
   | (e.g., "Document storage tied to investments" — added 5/5) | Page 2, Core Platform row 7 | ✅ Present, faithful |
   | (e.g., "Investment system first, not ERP" — hard boundary) | Out of scope para, page 3 | ⚠️ Partial — out of scope mentions only tax/integrations, doesn't restate "not ERP" framing |

6. Build the **reverse table**: every proposal scope item → source citation. Flag anything that doesn't trace.
7. Check the **boundary clauses**: out of scope, exclusions, customization model. Does each reflect a specific client statement, or is it freelance boilerplate?
8. Check **ordering**: are items in the proposal in an order that reflects client-stated priorities (or at least doesn't fight them)?
9. Check **terminology alignment**: where the client used a specific term (e.g., "PE drawdown tracking" vs. "capital commitments"), does the proposal use it or a near-synonym?

## Output Structure

Markdown file at `gala-holdings-tracker/research/proposal-scope-qa.md`:

```
# Proposal Scope QA — <project> v<N>

*Reviewer: <agent>. Date: YYYY-MM-DD CT. Inputs: <files read>.*

## Methodology
## Severity rubric
## Source → Proposal traceability
| Source item | Proposal location | Status | Note |
## Proposal → Source reverse traceability
| Proposal item | Source citation | Status |
## Boundary clauses
### Hard boundaries honored
### Boundaries weakened or missing
## Findings
### Critical
### Major
### Minor
### Cosmetic
## Top N to fix before send
## Items I could not evaluate (and why)
```

## Discipline

- Quote the exact source text when flagging a miss. "The 5/5 email says 'document storage tied to investments' — proposal page 2 says 'document storage' alone." Specificity beats vague concern.
- A missing item is worse than a poorly worded item. Optimize finding-priority for that.
- If the client volunteered a "nice to have" in discovery and the proposal moved it to paid add-on scope, flag it but don't grade it — that's a pricing call, not a scope call. Hand it to the pricing-qa agent.
- Don't grade copy quality. That's the contract-manager agent's job.
- If a source document is missing or unclear, say "cannot verify — source X not found" rather than fabricating findings.
