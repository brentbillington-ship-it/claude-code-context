# code-reviewer

> **Purpose:** Independent review of a diff, branch, or PR. Critical-mindset prompt; no self-approval bias.

## When to Invoke
- Before creating or merging a PR
- After a feature-complete but pre-commit checkpoint
- When you want a second opinion on an architectural decision
- When standing rules require review gate (client deliverables, Halff work)

## Prerequisites
- A clean working tree (commit or stash first)
- A base branch to diff against (usually `main`)
- Read access to the repo

## Playbook

1. Collect the diff: `git diff <base>...HEAD -- . ':!*.lock' ':!*.min.js'`
2. Enumerate changed files. For each: determine whether it's a logic change, config change, test, or doc. Put logic + config changes first.
3. Read each changed file IN FULL — don't trust the diff alone for reasoning about effects.
4. For each change, ask:
   - Is this logic correct? Walk through at least one edge case.
   - Does it break any invariant documented in CLAUDE.md?
   - Is the test (if any) testing the actual risk, or just the happy path?
   - Are error cases handled? Are they meaningful or decorative?
   - Is there a simpler version? Flag any premature abstraction.
   - Does the style match the surrounding file? (not the repo — the file.)
5. Check for:
   - Secrets (run `secret-scan-preedit.sh` patterns manually)
   - Destructive operations not guarded by a hook
   - New runtime dependencies (are they justified?)
   - Dead code or TODO: that should be an issue
6. Deliver findings in three sections: **must-fix**, **should-fix**, **nit/optional**.
7. Quote file + line for every finding.
8. If a finding is ambiguous, propose the fix rather than leaving it open.

## Success Criteria
- Every must-fix has a concrete remediation
- No self-approval ("LGTM") in under 3 file reads
- At least one edge case articulated per logic change
- Output is parseable (markdown with headers per section)

## Failure Modes & Recovery
- Diff too large (>500 LOC) → recommend splitting; review a logical subset only
- Reviewer and author use same model → flag this explicitly; recommend running via `hamelsmu/claude-review-loop` with Codex next time
- Tests are missing → block on "should-fix" with recommended test cases, don't approve "must-fix"

## Output Artifacts
- `reviews/<branch>-<YYYY-MM-DD>.md`
- Sections: Summary, Must-fix, Should-fix, Nits, Questions for author
