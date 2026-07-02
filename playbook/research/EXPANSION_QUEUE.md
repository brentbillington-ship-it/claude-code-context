# Expansion Queue — Wave 2 Deep-Dive Targets

*Refreshed 2026-07-02 (CT). verify-by: 2026-10-01*


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

---

## Status — 2026-07-02 review

**Wave 2 as compiled above was never executed.** The queue sat untouched from 2026-04-22 to 2026-07-02. A five-repo subset ran during the 2026-07-02 harness-review session (ponytail, disler/claude-code-hooks-mastery, wshobson/agents, diet103/claude-code-infrastructure-showcase, anthropics/skills); findings in `playbook/synthesis/` (2026-07-02 session report) and folded into the scout deltas.

### Re-ranked queue (top of list for the next research session)

| # | Repo | Why now | Status |
|---|------|---------|--------|
| 1 | `DietrichGebert/ponytail` | June's defining artifact; constraint-skill pattern | Deep-dived 2026-07-02 |
| 2 | `disler/claude-code-hooks-mastery` | Still the canonical hook reference | Deep-dived 2026-07-02 |
| 3 | `anthropics/skills` | Official SKILL.md house style | Deep-dived 2026-07-02 |
| 4 | `diet103/claude-code-infrastructure-showcase` | Auto-skill-routing via UserPromptSubmit | Deep-dived 2026-07-02 |
| 5 | `wshobson/agents` | Now multi-harness marketplace; packaging patterns | Deep-dived 2026-07-02 |
| 6 | `cobusgreyling/loop-engineering` | New Jun 2026; the "write loops" practitioner pattern | Queued |
| 7 | `parcadei/Continuous-Claude-v3` | Memory architecture; still unvisited from April list | Queued |
| 8 | `nizos/tdd-guard` | Drop-in TDD hooks; still current | Queued |
| 9 | `puran-water/autocad-mcp` | Direct Halff CAD fit; revisit when CAD work recurs | Queued |
| 10 | `pegasusheavy/claude-code-profiles` | Per-client isolation for BW | Queued |

Dropped from the April list: `obra/superpowers-marketplace` (superpowers-skills archived; core plugin still installed), `citypaul/.dotfiles` and `shanraisshan/claude-code-best-practice` (CLAUDE.md discipline now covered by standing rules + .claude/rules), `rohitg00/pro-workflow` and `centminmod/my-claude-code-setup` (auto memory covers the need).

### Quarterly refresh procedure

When any research file passes its verify-by date (ccc-doctor warns):
1. Re-verify platform facts against code.claude.com/docs + the official changelog. Update `anthropic.md` delta section.
2. WebSearch sweep for community deltas (Reddit/HN/GitHub/practitioners), one dated delta section per scout file. Anthropic pages are source of truth for feature facts; community sources are idea inputs.
3. Check star/activity on the queue above; re-rank; execute up to 5 deep-dives.
4. Bump every verify-by stamp one quarter. Date-stamp everything CT. Cite every source; mark UNVERIFIED claims.

