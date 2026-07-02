---
name: ccc-promote
description: Promote durable lessons from a project's UPDATE_TO_CCC.md into the CCC standing rules. Use when a project session ends with new entries in its UPDATE_TO_CCC.md, or when Brent says "promote the lessons". Drafts the standing-rules diff for approval; never commits without a go. Not for editing project-local rules.
allowed-tools: Read, Grep, Glob, Edit, Bash
---

# CCC Promote

The promotion pipeline used to depend on Brent remembering; two batches sat unpromoted from 2026-05-07 to 2026-07-02. This skill is the procedure.

## Steps

1. Read the project's `UPDATE_TO_CCC.md` in full. Identify entries not yet marked promoted.
2. Classify each unpromoted lesson:
   - **Amendment** to an existing rule (like the D6 green-on-main addition): draft the edit inside that rule's section.
   - **New durable rule**: draft it as the next L-number under standing rules § "Shipping Lessons", 3 to 6 lines, with source project and date in parentheses.
   - **New procedure or playbook**: propose a new file (AGENTS_*.md files must get an AGENT_MANAGER registry row in the same commit).
   - **Not durable** (project-specific detail): leave it in the project; say so.
3. Check each draft against the existing standing rules for contradictions. If the new lesson supersedes an old rule, the draft must edit the old rule too, never leave both.
4. Present the drafts as a numbered list. Stop. Wait for "go" (action gate applies to CCC like everywhere else).
5. On go: apply to CCC, commit with a CT-stamped message, then stamp the source UPDATE_TO_CCC.md entries with a promoted banner naming the date and where each lesson landed.
6. Run the ccc-doctor skill before finishing.
