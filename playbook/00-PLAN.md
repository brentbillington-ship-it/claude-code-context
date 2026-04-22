# Overnight Multi-Agent Sweep — Plan

**Session start:** 2026-04-22 (Central Time)
**Branch:** `claude/code-optimization-research-P2uAF` (per system rule; final delivery via draft PR to `main`)
**Owner:** Brent Billington — Billington Works LLC / Halff Associates

> Note: User-requested "Superpowers Brainstorm skill" is not in the available skills list for this session. Producing the plan directly following the same structure.

---

## Mission (one sentence)
Survey the state-of-the-art in Claude Code workflows across Reddit, GitHub, Anthropic docs, HN, and practitioner blogs, deep-dive the most promising repos, and produce a vetted upgrade playbook for CCC — with zero edits to top-level CCC files tonight.

---

## Subagent Roster

### Wave 1 — Breadth scouts (8 parallel)
| # | Agent | Tool bias | Output |
|---|-------|-----------|--------|
| 1 | reddit-scout | WebSearch / WebFetch | `research/reddit.md` |
| 2 | github-scout | WebSearch + GitHub MCP | `research/github.md` |
| 3 | anthropic-scout | WebFetch (docs.claude.com) | `research/anthropic.md` |
| 4 | hn-scout | WebSearch / WebFetch | `research/hn.md` |
| 5 | practitioner-scout | WebFetch (blogs) | `research/practitioners.md` |
| 6 | freelancer-scout | WebSearch | `research/freelancer.md` |
| 7 | anti-pattern-scout | WebSearch + WebFetch | `research/anti-patterns.md` |
| 8 | tool-catalog-scout | WebFetch + GitHub MCP | `research/tools.md` |

Each scout: returns a 1,500–3,000 token Markdown report ending with `## Promising repos for deep-dive`.

### Wave 2 — Depth deep-dives (up to 15 serial/batched)
One subagent per repo flagged in `EXPANSION_QUEUE.md`. GitHub MCP for file trees, WebFetch for raw content. Output: `research/deep-dive-<owner>-<repo>.md`. License logged every time.

### Wave 3 — Optional recursion
Only if Wave 2 surfaces net-new high-signal repos. Hard cap: 3 waves total. Stop when signal-per-hour drops.

### Synthesis (main session)
Sequential Thinking MCP → `synthesis/PATTERNS.md`, `GAP_ANALYSIS.md`, `RECOMMENDATIONS.md`, `ANTI_PATTERNS.md`.

---

## Phase Gates & Checkpoints

| Phase | Gate | CHECKPOINT.md update |
|-------|------|----------------------|
| 0 — Plan | `00-PLAN.md` written | Yes |
| 1 — Wave 1 | 8/8 reports in `research/` | Yes |
| 2 — Wave 2 | ≥10 deep-dives + EXPANSION_QUEUE.md | Yes |
| 3 — Synthesis | 4 files under `synthesis/` | Yes |
| 4 — Templates | ≥15 template files under `templates/` + 4 catalogs | Yes |
| 5 — Proposals | ≥5 proposals under `ccc-upgrade-proposals/` | Yes |
| 6 — Morning brief | `MORNING_BRIEF.md` + draft PR opened | Yes |

Commit cadence: after every phase gate, and after every 10 subagent reports. Prefix: `[playbook]`.

---

## Expected Output Inventory

```
playbook/
├── 00-PLAN.md                               ← this file
├── CHECKPOINT.md                            ← updated every phase
├── MORNING_BRIEF.md                         ← final deliverable
├── research/
│   ├── reddit.md, github.md, anthropic.md, hn.md,
│   ├── practitioners.md, freelancer.md, anti-patterns.md, tools.md
│   ├── EXPANSION_QUEUE.md                   ← aggregated + de-duped
│   └── deep-dive-<owner>-<repo>.md × 10–15
├── synthesis/
│   ├── PATTERNS.md
│   ├── GAP_ANALYSIS.md
│   ├── RECOMMENDATIONS.md
│   └── ANTI_PATTERNS.md
├── templates/
│   ├── agents/         ← 10 .md files
│   ├── skills/         ← 6 skill scaffolds
│   ├── claude-md/      ← 6 project-type templates
│   └── hooks/          ← 6 hook scripts
├── catalogs/
│   ├── MCP_CATALOG.md
│   ├── PLUGIN_CATALOG.md
│   ├── SLASH_COMMAND_CATALOG.md
│   └── MARKETPLACE_CATALOG.md
└── ccc-upgrade-proposals/
    └── NN-target.proposal.md × 5+
```

Rough target: ~45 files.

---

## Risks & Unknowns

| Risk | Mitigation |
|------|------------|
| GitHub MCP rate-limits | Fall back to raw.githubusercontent.com via WebFetch |
| Token budget overrun | Phase-gate commits; stop and checkpoint if main context crosses 80% |
| Subagent drift (returns HTML dumps) | Strict prompts: "condensed report, 1.5–3k tokens, no raw HTML" |
| License violations (copying GPL / unlicensed) | License check mandatory in every deep-dive; paraphrase when in doubt |
| Scout produces stale content (pre-v2.0) | Scope prompts to "last 6 months" where relevant |
| Superpowers Brainstorm unavailable | Produced plan manually; Sequential Thinking still usable for synthesis |
| Branch mismatch with user prompt | Following system rule → feature branch → draft PR (logged in CHECKPOINT) |

---

## Estimated Budget

| Axis | Estimate |
|------|----------|
| Wave 1 subagents | 8 × ~40k tokens input/output = ~320k subagent tokens |
| Wave 2 deep-dives | 12 × ~30k tokens = ~360k subagent tokens |
| Main-context synthesis | ~80k tokens |
| Template/proposal drafting | ~100k tokens |
| **Total session** | ~850k–1.1M tokens (fits within 1M context model) |
| Wall-clock | ~6–10 hours if serial, ~3–5 hours with aggressive parallelism |

Hard stop: if main-context usage crosses 80% during synthesis, checkpoint and halt.

---

## Guardrails (re-stated from task)

1. No edits to top-level CCC files tonight. All new content lives under `/playbook/`.
2. License discipline: MIT/Apache/BSD → adapt with attribution. GPL/no-license → paraphrase only.
3. No force pushes, no branch deletes, no history rewrites.
4. Desktop/mobile notification on completion OR blocker (per standing rules).
5. Paraphrase findings; quote sparingly; attribute always.

---

## Go condition
Pre-approved scope in the task authorizes execution after this plan is written. Proceeding to Phase 1.
