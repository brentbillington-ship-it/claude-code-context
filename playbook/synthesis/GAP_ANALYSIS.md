# Gap Analysis — CCC vs. State-of-the-Art (April 2026)

Honest, file-level comparison of Brent's current CCC repo against what high-quality setups are doing. Structured as **strengths to keep**, **gaps to close**, and **things CCC already does better than most**.

CCC baseline files audited:
- `CLAUDE_CODE_STANDING_RULES.md` (247 lines)
- `AGENT_MANAGER.md` (123 lines)
- `AGENTS_BROWSER_BOOTSTRAP.md`, `AGENTS_VISUAL_QA.md`, `AGENTS_COLOR_TRACE.md`, `AGENTS_DEPLOY_VERIFY.md`
- `README.md`, `hooks/`, `skills/`, `projects/` (empty or near-empty)

---

## Strengths CCC already has

| Strength | Why it matters | Comparable to |
|---|---|---|
| **Prime Directive** (never push without "go") | Deterministic safety. Clear user consent gate. | Boris Cherny's `/permissions` allowlist philosophy. |
| **AGENT_MANAGER.md registry + retirement triggers** | Agent lifecycle discipline. Forces deletion. Rare in surveyed repos. | Better than most — disler and wshobson do not have lifecycle discipline. |
| **Context thresholds (50/70/85/90%)** | Proactive compaction rules. Most repos don't quantify this. | Matches reddit.md signal #5; exceeds it by being concrete. |
| **MCP budget warning (~20k tokens)** | Anti-pattern scout flagged this; CCC already has the rule. | Matches tools.md #2. |
| **Selenium banned / Playwright enforced** | Prevents tool drift. | Better than ChrisWiles and most "best practice" repos. |
| **Two-tier PDF strategy** (Read for <20p, pdf-mcp for larger) | Token-aware. No one else does this. | Unique to CCC. |
| **CLAUDE.md 200-line rule already stated** | Matches community consensus. | Matches consensus. |
| **Active projects registered** | Context-switching across projects is documented. | Most setups have this implicit; CCC makes it explicit. |

---

## Gaps to close — ranked by impact

### HIGH impact

1. **No hook scripts in `hooks/` directory.** Only the Ruff hook is mentioned in CLAUDE_CODE_STANDING_RULES.md § Ruff PreToolUse Hook. Disler/nizos/shanraisshan ship 10–30 hook recipes. CCC's `hooks/` folder is empty.
   - *Close with:* `/playbook/templates/hooks/` with 6 hook scripts covering: formatter, rm-rf guard, secret scan, queue pump, checkpoint autosave, desktop notify.
   - *Source:* `github.md` (disler exemplar), `anti-patterns.md` (PostToolUse recursion).

2. **No skills in `skills/` directory.** README mentions `skills/pdf-extract.md` and `skills/scraper.md` but both are absent from the tree. Skills are Anthropic's recommended abstraction (not commands).
   - *Close with:* `/playbook/templates/skills/` with 6 SKILL.md scaffolds using proper YAML frontmatter + progressive disclosure.
   - *Source:* `anthropic.md` (skills page canonical), `practitioners.md` (Thariq).

3. **No per-project CLAUDE.md templates in `projects/`.** README promises them; folder is empty.
   - *Close with:* `/playbook/templates/claude-md/` with 6 project-type templates (campaign, civil-eng, web-app, scraping, Apps Script, client-deliverable).
   - *Source:* `freelancer.md` (3-tier CLAUDE.md, abhishekray07 pattern), `github.md` (citypaul).

4. **No reusable agent templates.** The four active agents are all project-specific (Canvassing-Map / Halff). Missing: generic `code-reviewer`, `research-subagent`, `security-scanner`, `doc-writer`, `deploy-verify` (generic).
   - *Close with:* `/playbook/templates/agents/` — 10 reusable `.md` files following AGENT_MANAGER.md template.
   - *Source:* `github.md` (wshobson/agents), `practitioners.md` (Thariq skill/agent split).

5. **No Billington Works client-delivery tooling.** CCC is silent on freelance delivery. No per-client profile pattern, no HANDOFF.md, no AI contract addendum, no case-study template.
   - *Close with:* `bw-client-deliverable` skill, `client-deliverable-packager` agent, `client-deliverable.CLAUDE.md` template, **proposal for a `/hooks/secret-scan-preedit.sh` mandatory on all client repos**.
   - *Source:* `freelancer.md` (entire report).

6. **No Serena / semantic code navigation.** CCC's MCP catalog doesn't mention Serena. Single biggest productivity gap for multi-file refactors.
   - *Close with:* add Serena to MCP_CATALOG + proposal to update CLAUDE_CODE_STANDING_RULES.md § MCP Servers.
   - *Source:* `tools.md` #1 Essential.

7. **No autocad-mcp reference** (direct Halff/civil fit). Brent does Civil 3D / AutoLISP work; this is the one MCP that's uniquely valuable for his stack.
   - *Close with:* MCP_CATALOG entry, optional skill `civil-eng-qto-helper` wrapping autocad-mcp dispatch.
   - *Source:* `tools.md`, `github.md` (puran-water/autocad-mcp).

### MEDIUM impact

8. **Superpowers Brainstorm is mandatory but Brainstorm skill isn't shipped in the CCC repo.** Standing rules reference it ("MUST invoke Brainstorm before touching any code") but the skill is external. If Superpowers ever changes, CCC breaks silently.
   - *Close with:* vendor a minimal `brainstorm.md` skill under `skills/` OR pin a Superpowers version + lock dependency.

9. **No checkpoint / resume strategy.** Standing rules discuss context thresholds but no hook/command for resuming cleanly.
   - *Close with:* `checkpoint-autosave.sh` hook + `/resume-session` slash command + `checkpoint-keeper` agent.
   - *Source:* `practitioners.md` (Simon Willison transcripts), `github.md` (parcadei Continuous-Claude-v3).

10. **No learnings / compound-engineering loop.** Standing rules has no "Claude edits its own CLAUDE.md after mistakes" discipline. This is the #2 tip across Reddit.
    - *Close with:* a `Stop` hook that captures `[LEARN]` blocks + a `/learn-rule` slash command + optional SQLite memory via `pro-workflow` pattern.
    - *Source:* `reddit.md` signal #2, `github.md` (rohitg00).

11. **No `/ultrareview` or equivalent in CCC.** v2.1.108 built-in is available; Brent may already have access, but standing rules don't mention it.
    - *Close with:* SLASH_COMMAND_CATALOG entry + `/ship` wrapper that enforces review-before-push.

12. **No secret-scan hook.** Critical for client work. CCC has no rule preventing a Write tool call from committing `ghp_…` or `sk-ant-…` to a file.
    - *Close with:* `secret-scan-preedit.sh` PreToolUse hook; deny patterns for common tokens (GitHub, Anthropic, OpenAI, AWS, GCP).
    - *Source:* `tools.md` (hooks worth adopting), `anti-patterns.md`.

13. **No devcontainer pattern.** For client work / YOLO-safe sessions, Trail of Bits' devcontainer is the community standard.
    - *Close with:* MARKETPLACE_CATALOG mention + optional proposal to vendor a `devcontainer.json` template.

### LOW impact (nice-to-have)

14. **No auto-README skill.** For client handoffs, a README generator is standard.
15. **No transcript-export tooling.** Simon Willison publishes his; useful for portfolio + audit.
16. **No notification hook for "blocked."** Standing rules mention desktop notify but no hook-based trigger.
17. **No CLAUDE.local.md convention documented.** Mentioned once; no guidance on what goes there.
18. **No output style customization.** v2.x supports Default/Explanatory/Learning + custom; CCC is silent.

---

## Where CCC is already better than the field

- **Agent lifecycle discipline** — retirement triggers and a registry table. Almost no surveyed repo does this.
- **Concrete context thresholds.** Most repos say "use /compact"; CCC says 50/70/85/90%.
- **Stack-specific positive framing.** "MUST use Playwright" beats "don't use Selenium" — matches Anthropic's memory guidance.
- **Python stack table is tight.** One row per tool, binary rule per row. Competes with ryoppippi/dotfiles.
- **Two-tier PDF strategy.** Unique and token-aware; nobody else documents this cleanly.
- **Explicit "review the file, don't theorize."** Matches Boris Cherny's creator advice verbatim.

---

## Summary

CCC is in the top 20% of `.claude/` setups by **discipline** (lifecycle rules, positive framing, stack-specific constraints) but in the bottom 50% by **artifact density** (no actual hooks, skills, or agent templates shipped). The playbook's job is to close the artifact gap while preserving the discipline.

The three highest-leverage additions, ranked:
1. Ship hook scripts (formatter + rm-rf guard + secret scan) — turns advisory rules into deterministic enforcement.
2. Ship skill scaffolds + 10 generic agents — gives every new project a working starting kit.
3. Ship the Billington Works client-delivery bundle (profile switcher + devcontainer reference + HANDOFF.md + AI addendum) — direct commercial value.

See `RECOMMENDATIONS.md` for the ordered action list with effort/impact/risk.
