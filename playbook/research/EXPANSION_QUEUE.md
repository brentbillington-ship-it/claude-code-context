# Expansion Queue — Wave 2 Deep-Dive Targets

Aggregated from 7 of 8 Wave 1 scout reports (anthropic-scout pending at time of queue compile; its expected repos — `anthropics/claude-code`, `anthropics/claude-code-security-review` — are already in the Wave 2 list).

## Ranking criteria
1. Real `.claude/` directory with agents/skills/hooks/commands (not README-only)
2. Production-looking CLAUDE.md (not demo fluff)
3. Multiple scout mentions OR unique technical approach
4. MIT / Apache / BSD license (fork-friendly) preferred
5. Active commits in last 90 days
6. Direct fit for Brent's stack (civil eng / Civil 3D, campaign tooling, scraping, Apps Script, freelance client work)

## Wave 2 — top 15 (locked in for launch)

| # | Repo | Why | License | Brent-fit |
|---|------|-----|---------|-----------|
| 1 | `disler/claude-code-hooks-mastery` | All 13 hook lifecycle events; the canonical hook reference. 4 scouts cited. | MIT | Hook patterns for any project |
| 2 | `wshobson/agents` | Largest high-quality agent library; best lexicon of role descriptions. 4 scouts cited. | MIT | Agent role templates |
| 3 | `anthropics/claude-code` | Official repo — plugins/, code-review examples, canonical SKILL.md patterns. | MIT | Foundational reference |
| 4 | `diet103/claude-code-infrastructure-showcase` | Auto-skill-activation via UserPromptSubmit hook; 500-line skill cap discipline. | MIT | Skill routing pattern |
| 5 | `parcadei/Continuous-Claude-v3` | Best memory/continuity architecture; YAML handoffs + pgvector. | MIT | Long-running project memory |
| 6 | `nizos/tdd-guard` | Drop-in TDD hooks for 8 test frameworks. | MIT | Pytest / Jest projects |
| 7 | `rohitg00/pro-workflow` | Self-correcting memory: SQLite + FTS + `[LEARN]` Stop hook. | Unknown | Memory kernel |
| 8 | `shanraisshan/claude-code-best-practice` | Opinionated practices; 200-line CLAUDE.md discipline. | MIT | Config discipline |
| 9 | `centminmod/my-claude-code-setup` | Memory-bank CLAUDE.md pattern + synchronizer subagent. | Unknown | Multi-project memory |
| 10 | `puran-water/autocad-mcp` | **Direct stack fit** — only credible AutoLISP/Civil 3D MCP bridge. | Unknown | Halff CAD work |
| 11 | `pegasusheavy/claude-code-profiles` | Profile-per-client switcher — directly relevant to Billington Works. | Unknown | Client isolation |
| 12 | `obra/superpowers-marketplace` | Jesse Vincent's curated marketplace; CCC already uses Superpowers core. | Check | Extends existing |
| 13 | `gotalab/cc-sdd` | Spec-driven-dev harness; 17 Agent Skills; `/kiro-*` command chain. | Unknown | Spec-driven projects |
| 14 | `citypaul/.dotfiles` | The viral CLAUDE.md everyone cites. | Unknown | CLAUDE.md template |
| 15 | `trailofbits/skills-curated` | Security-audited marketplace; every plugin code-reviewed. | Check | Supply-chain story |

## Deferred to potential Wave 3 (or skip)

- `SuperClaude-Org/SuperClaude_Framework` — heavyweight persona framework; Brent's stack doesn't need it
- `ChrisWiles/claude-code-showcase` — clean minimal template; covered by cc-sdd + hooks-mastery
- `obie/claude-on-rails` — Rails-specific; Brent doesn't use Rails
- `Piebald-AI/claude-code-lsps` — interesting but underexplored; revisit post-MVP
- `VoltAgent/awesome-claude-code-subagents` — curation, not template source
- `ykdojo/claude-code-tips` — tip list, not configs
- `hamelsmu/claude-review-loop` — Codex-reviewer pattern; document via synthesis rather than deep-dive
- `davila7/claude-code-templates` — 600+ agents, better as reference
- `abhishekray07/claude-md-templates` — covered by citypaul + synthesis
- `willseltzer/claude-handoff` — handoff pattern; extract via synthesis
- `hesreallyhim/awesome-claude-code` — CC-BY-NC-ND-4.0 license, citable only
- `getagentseal/codeburn` — observability TUI, not config source
- `anthropics/claude-code-security-review` — GitHub Action, not config pattern
- `serpro69/claude-toolbox` — 10-skill pipeline; revisit if opinionated skill pattern wanted
- `simonw/claude-code-transcripts` — transcript tooling; revisit if memory needed
- `oraios/serena` — MCP server, covered in tool catalog already

## Stopping rule
Wave 2 caps at 15 deep-dives. If Wave 2 surfaces net-new high-signal repos, Wave 3 gets up to 5 more. Hard stop at 3 waves total.
