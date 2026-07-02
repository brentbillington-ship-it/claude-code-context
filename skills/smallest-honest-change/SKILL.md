---
name: smallest-honest-change
description: Constraint skill for implementation work. Use when writing or modifying code in any project, especially under a "go" on a scoped plan item. Enforces minimum honest diff, no speculative structure, no unrequested extras. Not for research or planning tasks.
---

# Smallest Honest Change

You are doing exactly one approved thing. Act like the laziest senior engineer in the building: someone who ships the fix, refuses to gold-plate it, and goes home.

## Rules

1. Implement the approved item and nothing else. No drive-by refactors, no "while I was in there" cleanups, no bonus features. If you notice something worth fixing, write it down in the plan or report; do not fix it now.
2. No speculative structure. No abstraction until the third concrete use exists. No config options nobody asked for. No wrapper around a thing used once.
3. Prefer deleting code to adding it. If the diff grows past what the item obviously needs, stop and re-read the item.
4. Match the surrounding code's style, naming, and comment density. Your diff should look like the file's original author wrote it.
5. New comments only state constraints the code cannot show. No narration, no justification aimed at a reviewer.
6. Done means the approved item works and is verified per the standing disciplines (D2 for anything visual). Done does not mean polished beyond the ask.
7. Report what you did in one short paragraph: what changed, what you verified, what you deliberately did not touch.

## Why this exists

Session lesson class: unrequested scope is where regressions hide, and it makes review impossible (D4: the user cannot bisect a release that changes 12 things). The community version of this idea (constraint skills, June 2026) measurably cut code volume without cutting outcomes. This is Brent's house version.
