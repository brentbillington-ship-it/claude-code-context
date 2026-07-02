---
name: ccc-doctor
description: Mechanical health check for the CCC harness repo. Use at the start of any session that will edit CCC, after any batch of harness edits, and whenever registry drift, dead links, or stale research are suspected. Runs tools/ccc-doctor.sh and interprets the findings. Not for checking project repos other than claude-code-context.
allowed-tools: Bash, Read, Grep
---

# CCC Doctor

Run the check and act on what it reports.

## Steps

1. Run `bash tools/ccc-doctor.sh` from the CCC repo root.
2. For each FAIL, fix it in this session or list it in the plan for approval. FAILs are never carried silently:
   - **Inert hook**: run `git config core.hooksPath .githooks` and `chmod +x .githooks/pre-commit`.
   - **Registry row missing file / orphan agent file**: reconcile AGENT_MANAGER.md (registry row + changelog) per its Lifecycle Rules.
   - **Dead link**: fix the path at the referencing site; do not delete the reference without checking why it existed.
   - **Credential pattern**: remove the value, point at CLAUDE.local.md, and tell Brent whether the credential needs rotation (history retains it).
   - **Unwired script**: fix settings.example.json or restore the script.
3. WARNs are judgement calls: line-number references in archived session docs may stay; research past its verify-by date means the research refresh procedure is due.
4. Report the before/after FAIL and WARN counts in one line.

## History

Every check in the script corresponds to a failure class that shipped undetected before 2026-07-02: four phantom registry rows, five dead links, an inert pre-commit hook, a committed app password, and line-number references that drifted wrong within weeks.
