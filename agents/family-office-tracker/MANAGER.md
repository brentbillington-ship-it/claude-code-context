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

## Playbook

1. Pull CCC and read CLAUDE_CODE_STANDING_RULES.md, AGENT_MANAGER.md, and any prior family-office tracker artifacts.
2. Confirm engagement repo exists, locate discovery recap and schema artifact.
3. Run Superpowers Brainstorm. Output to `research/00_brainstorm.md`. Get explicit "go" from Brent before spawning sub-agents *unless* Brent has authorized autonomous execution.
4. Spawn agents in dependency order: Pricing first (proposal-relevant headline), then parallel batch (Aesthetics + Data Viz + Features), then Finance, then Synthesis.
5. After each sub-agent completes, validate output against its spec (deliverable file exists, minimum source count met, structure matches CCP, no BB-Notes leakage).
6. After Synthesis, write `07_build_ccp.md` (build CCP for next session) and append generalizable notes to `claude-code-context/playbook/research/family-office-tooling.md`.
7. Send mobile push notification with summary including pricing headline.
8. Stop. No commits, no pushes.

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
