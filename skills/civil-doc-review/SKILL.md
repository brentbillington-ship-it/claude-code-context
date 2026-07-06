---
name: civil-doc-review
description: Review civil plan sets and multi-consultant project documents — sheet-level comparison, scope-overlap and utility-conflict detection, spec/product cross-checks. Use when comparing plan-set revisions, checking consultant scopes against each other, or verifying a submittal against contract documents. Not for quantity take-offs (use civil-eng-qto-helper) or AutoLISP code (use autolisp-reviewer).
allowed-tools: Read, Grep, Glob, Bash
---

# Civil Document Review

Created 2026-07-06 from Celina downtown-streets sessions (AVO 65429
coordination + plan-set comparison lessons). v1 scope is what those
sessions proved out; extend as new review types recur.

## Steps

1. **Sheet index first.** Before comparing two plan-set PDFs, read each
   set's sheet index page and diff the indexes. That one-page read
   answers "what changed / what's missing" before any sheet-by-sheet
   work — never start by bulk-extracting title blocks (a 600-title-block
   CAD scrape once substituted for a single index-page read).
2. **Large PDFs per the two-tier rule.** Standing rules § pdf-mcp: Read
   tool under 20 pages, incremental search/paginate above. Never dump a
   full plan set into context.
3. **Multi-consultant conflict pass.** When more than one firm has
   scope in the same corridor, build a matrix: consultant × street/asset
   × discipline (paving, drainage, water, sewer, franchise). Flag every
   cell where two firms touch the same asset, and every asset no firm
   owns. Name the open coordination questions explicitly (Celina: K-H /
   Carollo water-sewer split on Task 400; TRC plan overlap on
   Oak/Louisiana/Ohio).
4. **Spec/product compatibility check.** For any named product, verify
   it against the governing spec section and the manufacturer's data
   sheet — application (vertical/overhead vs horizontal), substrate prep
   and bonding-agent pairing, cure times, exposure class. Quote both the
   spec clause and the data-sheet line so the finding is checkable.
5. **Findings format.** Severity-tagged (conflict / gap / verify-with-PM
   / editorial), each finding citing sheet number or spec section.
   Deliverable prose follows standing rules § Communication Style →
   Outbound writing.

## Failure modes

- Comparing sets sheet-by-sheet without diffing indexes first (wasted
  context, missed added/dropped sheets).
- Asserting a utility conflict from plan geometry alone — flag as
  verify-with-PM unless profiles/details confirm.
- Trusting a product name's marketing page over the spec section and
  data sheet.
