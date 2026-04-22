# GitHub Scout — Report

Survey date: 2026-04-22. Scope: real repos with production-looking `.claude/` (agents, skills, commands, hooks, settings.json). Rate-limited MCP `get_file_contents` blocked on external repos; fell back to raw.githubusercontent.com for READMEs and LICENSE files. Star counts are GitHub API values (late Apr 2026) and mix organic signal with heavy viral/SEO growth — interpret accordingly.

## Starter list — quick take

| Repo | Stars | What stood out | License | Rating |
|---|---:|---|---|---|
| `hesreallyhim/awesome-claude-code` | 40.1k | Curation hub; pointer-only, no real `.claude/`. Good index into the ecosystem. | CC-BY-NC-ND-4.0 | B — directory, not a pattern source |
| `shanraisshan/claude-code-best-practice` | medium | Crisp split of agents vs commands vs skills; advocates CLAUDE.md <200 lines, aggressive context hygiene, `/compact` discipline, feature-scoped subagents. Real `.claude/hooks/HOOKS-README.md` present. | MIT | A |
| `nikiforovall/claude-code-handbook` | — | README 404 on main; repo exists but could not confirm live structure this pass. Likely handbook-style docs. | unknown | C — needs verification |
| `diet103/claude-code-infrastructure-showcase` | 9.5k | Auto-skill-suggestion via UserPromptSubmit hook + `skill-rules.json`; 500-line skill cap with progressive disclosure; dev-docs pattern to survive context resets. | MIT | A+ |
| `davepoon/buildwithclaude` | 2.8k | Aggregator / hub for skills/agents/commands/hooks across Claude Code, Desktop, SDK. More catalog than template. | unknown | B |
| `disler/my-claude-code-sub-agents-build-themselves` | — | Meta-agent pattern: agents that emit other agents. Relevant ideas mirrored in `disler/claude-code-hooks-mastery`. | — | B+ |
| `disler/claude-code-hooks-mastery` | 3.5k | All 13 hook lifecycle events with Python scripts, meta-agent, builder/validator team workflow, deterministic safety gates (blocks dangerous cmds + sensitive files), 9 status-line variants, 8 output styles. Best single reference for the hooks surface area. | MIT | A+ |
| `SuperClaude-Org/SuperClaude_Framework` | 22.4k | Personas + command palette framework. Heavier philosophy; pip-installable. Useful command taxonomy to crib. | MIT | A- |
| `buildermethods/agent-os` | — | Standard-discovery + spec-shaping lightweight layer; editor-agnostic (Claude, Cursor, Antigravity). Good prose on "standards as artifacts." | unknown | B+ |
| `rosmur/claudecode-best-practices` | — | Not found in this pass. | — | — |
| `awattar/claude-code-best-practices` | — | Not found in this pass. | — | — |
| `bmadcode/BMAD-METHOD` | — | 12+ persona agents, "Party Mode" multi-persona collab, 34+ workflows. Methodology-heavy; agent role inventory is the steal. | unknown | B+ |
| `revfactory/harness` | — | Not found by repo search. | — | — |
| Daniel Rosehill — `Claude-Code-Plugins` | 9 | Small personal marketplace; thin substance. | unknown | C |

## Beyond the starter list — surfaced by code search

- `wshobson/agents` — 34k stars. Largest curated subagent pack; orchestration + workflow prompts. MIT. High-value agent definitions to mine.
- `VoltAgent/awesome-claude-code-subagents` — 17.9k. 100+ specialized subagents covering dev verticals.
- `parcadei/Continuous-Claude-v3` — 3.7k. **Standout**: continuity ledgers + YAML handoffs + pgvector memory daemon; "compound, don't compact." MIT.
- `nizos/tdd-guard` — 2k. Hook-based TDD enforcement across Vitest/Jest/pytest/PHPUnit/Go/Rust/RSpec/Minitest. MIT. Cleanest single-purpose hook plugin.
- `ChrisWiles/claude-code-showcase` — 5.8k. Clean minimal split of skills/agents/hooks/commands + GitHub Actions.
- `rohitg00/pro-workflow` — 2k. SQLite + FTS self-correcting memory; corrections → rules → auto-loaded on SessionStart; `/learn-rule` command; `[LEARN]` block capture from Stop hook.
- `obra/superpowers-marketplace` — 870. Jesse Vincent's curated marketplace; "Superpowers" core library + Elements of Style + Private Journal MCP.
- `trailofbits/skills-curated` — 369. Security-audited marketplace; every plugin code-reviewed by ToB — meaningful supply-chain story.
- `gotalab/cc-sdd` — 3.1k. Spec-driven dev harness across 8 agents; installs 17 Agent Skills; `/kiro-*` command chain.
- `centminmod/my-claude-code-setup` — 2.2k. CLAUDE.md memory-bank pattern with pattern docs, ADRs, active context, troubleshooting; `memory-bank-synchronizer` subagent.
- `iannuttall/claude-agents` — 2k. Individual subagents repo — widely forked reference.
- `jeremylongshore/claude-code-plugins-plus-skills` — 2k. Big marketplace with `ccpi` CLI package manager.
- `glittercowboy/taches-cc-resources` — 1.8k + `plugin-freedom-system`. Real SubagentStop.sh in repo.
- `ComposioHQ/awesome-claude-plugins` — 1.4k. Plugin-system focused curation.
- `obie/claude-on-rails` — 795. Rails-shaped agent swarm (Architect, Models, Controllers, Views, Services, Tests, DevOps) — template for any framework split.
- `gmickel/flow-next` — 572. Plan-first workflow, worker subagents, Ralph autonomous loop, cross-model reviews.
- `mhattingpete/claude-skills-marketplace` — 556. Software-eng focused skills (git, testing, review).
- `Piebald-AI/claude-code-lsps` — 419. Plugins that expose LSP servers to Claude — underexploited pattern.
- `numman-ali/n-skills` — 975. Claude + Codex cross-tool skills.
- `kousen/claude-code-training` — training repo, has real `.claude/hooks/index.ts`.

## Patterns I saw repeatedly

- **Four-role mental model:** skills teach, agents specialize, hooks automate, commands orchestrate. Repeated across diet103, ChrisWiles, shanraisshan.
- **Progressive disclosure on skills.** 500-line cap on `SKILL.md`; deeper files loaded only when needed.
- **UserPromptSubmit as a router.** Multiple repos use it to suggest/auto-activate skills (diet103) or track corrections (rohitg00).
- **Context hygiene as a first-class concern.** CLAUDE.md <200 lines; `/compact` + `/clear` discipline; reset rather than pollute.
- **Memory layered outside the context window.** Markdown ledgers + YAML handoffs + SQLite/pgvector stores (parcadei, rohitg00, centminmod). All avoid relying on Claude's own compaction.
- **SubagentStop used for logging/learning extraction** more than for flow control.
- **Safety gates in hooks, not prompts.** disler blocks sensitive file access and dangerous bash via hooks so it's deterministic.
- **Builder/validator agent pairs.** Plan agent writes, review agent checks, only then code agent ships.
- **Meta-agents that spawn other agents** (disler, flow-next Ralph mode).
- **Marketplace/plugin packaging is becoming table stakes** — several repos ship a `marketplace.json`-style manifest.

## Best single-file exemplars

- `disler/claude-code-hooks-mastery` → `.claude/settings.json` + `.claude/hooks/*.py` — reference implementation of every hook event.
- `shanraisshan/claude-code-best-practice` → `.claude/hooks/HOOKS-README.md` — human-readable guide to hook role-per-event.
- `diet103/claude-code-infrastructure-showcase` → `skill-rules.json` + UserPromptSubmit hook — auto-skill activation.
- `parcadei/Continuous-Claude-v3` → `.claude/hooks/README.md` + `thoughts/ledgers/` + `thoughts/shared/handoffs/` — memory system template.
- `nizos/tdd-guard` → the PreToolUse/PostToolUse hook set — drop-in TDD enforcement.
- `rohitg00/pro-workflow` → `/learn-rule` command + `[LEARN]` Stop-hook capture — self-correcting memory kernel.
- `wshobson/agents` → individual agent `*.md` files — best lexicon of agent role descriptions.
- `obie/claude-on-rails` → framework-sliced agent swarm config.

## Red flags I saw

- **Curation farms with inflated stars.** Several `awesome-*` / "toolkit" repos list thousands of items without real `.claude/` content or originality (e.g. `rohitg00/awesome-claude-code-toolkit`, `wesammustafa/Claude-Code-Everything-You-Need-to-Know`). Useful as pointers, not sources.
- **Marketplace proliferation.** ~10 "marketplace" repos created around Oct–Dec 2025. Most are thin JSON manifests pointing at others' work.
- **`.claude/settings.json/settings.json.<timestamp>` anti-pattern** (Nerfherder16/BrickLayer) — someone's tool nested a dir where a file belongs. Easy to find; do not copy.
- **Licensing landmines.** `hesreallyhim/awesome-claude-code` is CC-BY-NC-ND-4.0: non-commercial + no derivatives. Citable, not forkable.
- **Heavy README, empty `.claude/`.** Several high-star repos are slide decks + marketing; substance lives in a single directory that's often stale.
- **Farmed star counts.** 40k stars on a 1-year-old list repo is suspicious; treat numbers as rough signal, not gospel.

## Promising repos for deep-dive (Wave 2 targets)

Ranked by signal-to-noise, not raw stars.

1. `disler/claude-code-hooks-mastery` — every hook event, real scripts. MIT. Last commit: 2026-04-21.
2. `parcadei/Continuous-Claude-v3` — best memory/continuity architecture I saw. MIT. 2026-04-21.
3. `diet103/claude-code-infrastructure-showcase` — auto-skill-activation + progressive disclosure. MIT. 2026-04-22.
4. `nizos/tdd-guard` — drop-in hook plugin, multi-framework. MIT. 2026-04-21.
5. `wshobson/agents` — highest-quality agent role library. MIT. 2026-04-22.
6. `rohitg00/pro-workflow` — self-correcting memory, SQLite-backed. 2026-04-22.
7. `shanraisshan/claude-code-best-practice` — opinionated practices doc. MIT. recent.
8. `ChrisWiles/claude-code-showcase` — clean minimal template incl. GH Actions. 2026-04-22.
9. `gotalab/cc-sdd` — spec-driven harness w/ 17 Skills. 2026-04-22.
10. `centminmod/my-claude-code-setup` — CLAUDE.md memory bank + synchronizer subagent. 2026-04-22.
11. `obra/superpowers-marketplace` — Jesse Vincent's "Superpowers" skills. 2026-04-21.
12. `trailofbits/skills-curated` — vetted marketplace; supply-chain story. 2026-04-22.
13. `obie/claude-on-rails` — best framework-slice agent template. 2026-04-21.
14. `SuperClaude-Org/SuperClaude_Framework` — persona + command palette taxonomy. MIT. 2026-04-22.
15. `Piebald-AI/claude-code-lsps` — LSP-as-plugin pattern, underexplored. 2026-04-22.

Wave 2 should clone 1–6 locally and inspect `.claude/` trees; others can stay READMEs-only unless a specific pattern is needed.
