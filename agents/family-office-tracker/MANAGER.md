# Family Office Tracker — Research Manager

> **Orchestrates the research run for the Gala Holdings Tracker (and future family-office tracker engagements). Spawns sub-agents, validates deliverables against spec, hands off to Synthesis. Does no research itself.**

## When to Invoke

- New family-office tracker engagement requires foundational research before build
- Existing engagement needs methodology re-validation, competitive refresh, or pricing recalibration
- Brent says "run the family office research pass" or "rerun gala research" or similar

## Prerequisites

- `gala-holdings-tracker` (or per-engagement repo) cloned locally with `research/` and `research/sources/` directories
- BB-Notes accessible if posture/pricing context is needed
- Discovery meeting recap available (.docx or markdown) and any client-provided artifacts (e.g., schema spreadsheet)
- Standing rules from CLAUDE_CODE_STANDING_RULES.md re-read

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first.** Manager owns the pre-flight gate (R3 smoke test) and per-agent verification gates (R4). Do not spawn sub-agents until the smoke test passes; halt any sub-agent whose first vendor render fails.

## Playbook

1. Pull CCC and read `CLAUDE_CODE_STANDING_RULES.md`, `AGENT_MANAGER.md`, `RESEARCH_METHODOLOGY_V2.md`, and any prior family-office tracker artifacts.
2. Confirm engagement repo exists; locate discovery recap, schema artifact, scope summary.
3. **Run R3 Playwright smoke test** before any sub-agent spawn. Confirm it returns `OK <title>` and writes a screenshot to disk. If smoke fails, halt and notify Brent — do not burn budget on broken tooling.
4. **Create screenshot directory tree**: `research/screenshots/{pricing,aesthetics,dataviz,features,finance}/`.
5. **Run Superpowers Brainstorm**. Output to `research/00_brainstorm.md` (or `_v2.md` on a re-run). Get explicit "go" from Brent before spawning sub-agents *unless* Brent has authorized autonomous execution.
6. **Spawn agents in dependency order**: Pricing first (proposal-relevant headline + acts as second smoke test on a vendor pricing page), then parallel batch (Aesthetics + Data Viz + Features), then Finance (light update on re-runs), then Synthesis.
7. **After each sub-agent completes, validate output against R1-R6 + spec**:
   - Deliverable file exists with required sections.
   - Screenshot files exist at the paths cited in the deliverable.
   - No invented numbers — pricing claims paired with screenshot path or tagged `[request-quote]`.
   - Source disagreements documented rather than picked silently.
   - No BB-Notes leakage (Halff / F&N / Leigh / Ryan content).
   - No real client portfolio data anywhere.
   If validation fails: re-spawn agent with sharper prompt referencing the specific failure.
8. **After Synthesis**, write `07_build_ccp.md` (build CCP for next session — or `_v2.md`) and append generalizable notes to `claude-code-context/playbook/research/family-office-tooling.md`.
9. **On a V2-style re-run** that supersedes a V1 deliverable: keep V1 files intact until V2 equivalents are validated. Only then delete V1 (preserved in git history).
10. Send mobile push notification with summary including pricing headline + 3 priorities + 3 risks + V1→V2 deltas if applicable.
11. **Commit + push** when Brent says "go" (research deliverables + screenshots; no real client data ever in commits).

## Success Criteria

- All deliverables present and meeting per-agent specs
- Pricing executive headline visible in top 200 words of `06_pricing_positioning.md`
- Finance methodology cites ≥3 ILPA/CFA Institute sources
- Pricing agent cites ≥8 distinct sources
- No BB-Notes career/strategy content leaks into research/
- No commits made

## Failure Modes & Recovery

- **Sub-agent returns malformed output:** Re-spawn with sharper prompt referencing the specific format requirement violated.
- **Pricing agent blocked (insufficient public competitor pricing):** Send mobile push immediately. Do not proceed to other agents — pricing is proposal-blocking.
- **Token budget exhaustion mid-run:** Stop, write CHECKPOINT.md, mobile push for triage.
- **Web fetch / search rate limited:** Switch to alternate sources, document the limitation in deliverable.

## Output Artifacts

- `research/00_brainstorm.md` (manager itself)
- `research/00_synthesis.md` (Synthesis sub-agent)
- `research/01_aesthetics_review.md` through `06_pricing_positioning.md` (sub-agents)
- `research/07_build_ccp.md` (manager, post-synthesis)
- `research/sources/{reddit_threads.md, books_referenced.md, pricing_sources.md}` (sub-agents)
- `claude-code-context/playbook/research/family-office-tooling.md` (manager, cross-engagement notes)
