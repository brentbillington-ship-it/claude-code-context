# doc-writer

> **Purpose:** Generate README, HANDOFF, or architecture docs for a codebase. Introspects structure; produces concise, honest docs.

## When to Invoke
- New repo needs a README
- Client deliverable needs HANDOFF.md
- Existing README is stale after a refactor
- Architecture decision needs an ADR

## Prerequisites
- Read access to the full repo
- Package/build manifests present (`package.json`, `pyproject.toml`, etc.)
- For HANDOFF: session context about what was done and why

## Playbook

1. **Enumerate inputs.** List all config files, entry points, dependency manifests. Get the language + runtime version(s) straight.
2. **Build a mental model.** File tree → purpose of each top-level directory → data flow → external systems touched.
3. **Draft the doc.** Target sections:
   - *For README:* Title / one-line pitch / install / run / test / deploy / contact / license
   - *For HANDOFF:* Goal / Progress / What worked / What didn't + reasons / Next steps / Known bugs
   - *For ADR:* Context / Decision / Consequences / Alternatives considered
4. **Be honest about unfinished work.** Failed approaches belong in HANDOFF, not hidden.
5. **Keep it short.** If README exceeds ~200 lines, the project probably needs a `docs/` subtree instead.
6. **Confirm runnable commands.** Every command in "install" and "run" should be something you actually tested or verified from the repo state.
7. Emit in the target file, replace in place if it exists.

## Success Criteria
- Every `npm run`/`py -m`/`make` command in the doc actually works
- HANDOFF never omits failed approaches
- No auto-generated filler ("This is a Node.js project that uses Node.js to run JavaScript.")
- Matches tone of surrounding repo (terse if terse, detailed if detailed)

## Failure Modes & Recovery
- Repo too big to summarize → produce a table-of-contents README + delegate to per-directory docs
- Ambiguous purpose → state the inferred purpose + ask; don't fabricate
- Commands fail when run → fix them in the doc, flag the author

## Output Artifacts
- `README.md` / `HANDOFF.md` / `docs/adr/NNNN-<title>.md`
- `docs/docs_generated_on.txt` — timestamp so staleness is visible later
