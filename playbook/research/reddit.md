# Reddit Scout — Report

Scope: r/ClaudeAI, r/ClaudeCode, r/LocalLLaMA, r/ChatGPTCoding, last ~6 months (through 2026-04-22). Note: direct Reddit fetches were blocked for this agent, so signals below were gathered via web-indexed summaries of Reddit threads plus community blogs that quote them. Primary Reddit URLs are provided where search returned them; otherwise the best-available proxy source is cited and marked "(proxy)".

## Top signals (ranked)

1. **CLAUDE.md must be short, pruned, and iterated — not a handbook.** Community consensus converging on <200 lines / <2K tokens per file because every turn re-injects it. Stuff beyond that gets ignored ~20% of the time. Push detail into Skills or linked docs. [Reddit aggregator](https://www.morphllm.com/claude-code-reddit) (proxy) · [HumanLayer write-up of Reddit consensus](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
2. **"Make Claude edit its own CLAUDE.md after each mistake."** The most repeated pro-tip: after a bug, say "update CLAUDE.md so you don't do that again." Over weeks the mistake rate drops visibly. [YK Thread/mega-thread sourced from r/ClaudeCode](https://www.threads.com/@ykdojo/post/DTdoP1ekh_b/my-top-claude-code-tips-from-months-of-intense-use-a-mega-thread) · [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips)
3. **Hooks are deterministic; CLAUDE.md is advisory.** Recurring framing: "if it must happen every time, it's a hook, not a memory rule." Linting, formatting, secret scans, rm-rf guards. [eesel recap of r/ClaudeCode threads](https://www.eesel.ai/blog/hooks-in-claude-code) · [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)
4. **SubagentStop queue-handoff pattern for sequential orchestration.** Because subagents can't invoke each other, users register a SubagentStop hook that reads a small queue file and echoes the next "Use the X subagent on Y" instruction. Parent executes it. Stop hook acts as safety net. [anthropics/claude-code#5812 (proxy)](https://github.com/anthropics/claude-code/issues/5812) · [anthropics/claude-code#8093 (proxy)](https://github.com/anthropics/claude-code/issues/8093)
5. **Disable auto-compact, run /compact manually at ~80%.** Threads report auto-compact wiping ~33% of usable window and returning generic/degraded answers. Manual /compact with an explicit "preserve these decisions" preamble works better. [Threads mirror of r/ClaudeAI tip](https://www.threads.com/@melvynxdev/post/DS8uN9ciayp/claude-code-pro-tip-disable-auto-compact-youre-losing-of-your-context-window) · [issue #13112 quoting reddit complaints](https://github.com/anthropics/claude-code/issues/13112)
6. **Model routing is the cost lever, not prompts.** ~80% Sonnet 4.6 / 20% Opus 4.7 is the repeated ratio. Opus 4.7 burns 1.5–3x more tokens than 4.6 when prompted lazily — the "ambiguity tax." [Reddit reception roundup](https://botmonster.com/posts/claude-opus-4-7-x-reddit-reception/)
7. **Skill description field is everything.** Auto-invocation only works with a WHEN + WHEN-NOT pattern in the SKILL.md frontmatter description. Generic descriptions never fire. [BSWEN summary of community threads](https://docs.bswen.com/blog/2026-03-24-skill-triggering/)
8. **--dangerously-skip-permissions = use only in a container/VM.** Multiple Reddit horror stories ([Wolak](https://github.com/anthropics/claude-code/issues/10077), Dec-2025 `~/` expansion). Simon Willison amplified from Reddit. [simonw on X](https://x.com/simonw/status/1998447540916936947)
9. **Plan Mode before Code Mode for any multi-file change.** Reddit users treat Plan Mode (shift-tab) as mandatory for refactors; checkpoints + Esc-Esc rewind covers the rest. [claudelog plan-mode page (reddit-citing)](https://claudelog.com/mechanics/plan-mode/)
10. **`claude --resume` + named sessions for multi-day work.** Plus git worktrees so parallel sessions don't stomp each other. [kentgigger writeup of r/ClaudeCode practice](https://kentgigger.com/posts/claude-code-conversation-history)

## Recurring themes

- "Invest in the system, not the prompt." People who build hooks/skills/CLAUDE.md stay; people using it like autocomplete churn out.
- Token anxiety is the dominant emotion on r/ClaudeAI since March 2026 — weekly/5-hour cap tightening + Opus 4.7 burn rate. Every thread eventually becomes a token-saving thread.
- Subagents are loved for parallel research, criticized for sequential work: each invocation rebuilds context from scratch, so chains feel slow. Best use case = "don't pollute my main context with search results I'll never re-read."
- Skills > Commands > Subagents > Plugins as the preferred abstraction order — skills win on token efficiency because they load only when triggered.
- Plugin marketplaces are fragmenting (tonsofskills, claudemarketplaces, aitmpl, official). Reddit sentiment: most plugins don't earn their keep; keep ~5–10 local skills + 3–5 plugins.

## Notable disagreements

- **Subagents in existing codebases**: Camp A says they parallelize brilliantly; Camp B says they're slower than a single agent for anything but brand-new or self-contained tasks because of cold-context cost. [claudekit post citing both sides](https://claudekit.cc/blog/vc-04-subagents-from-basic-to-deep-dive-i-misunderstood)
- **Opus 4.7 vs Sonnet 4.6 as daily driver**: One camp (r/ClaudeCode) says always-Opus for coding after 4.7. Other camp says Sonnet 4.6 wins on $/task and Opus only for arch/refactor. [NxCode roundup of reddit views](https://www.nxcode.io/resources/news/claude-opus-4-7-vs-4-6-which-model-2026)
- **Auto-compact on vs off**: Anthropic advises leaving it on; loud Reddit minority insists disabling it reclaims 33% context. [#6123](https://github.com/anthropics/claude-code/issues/6123). Contradicts official guidance — flag this.
- **Global vs project CLAUDE.md**: Some swear by ~/.claude/CLAUDE.md for cross-project style; others call it a hidden token tax on every session and keep it empty.
- **YOLO mode**: Partitioned between "containers make it safe and 10x productive" and "never, under any circumstances." Anthropic's own `auto mode` positioning splits the difference.

## Token-saving tricks worth testing

- Trim CLAUDE.md under 2K tokens; move deep context into skills invoked on demand.
- Add a .claudeignore (node_modules, dist, .venv, large fixtures, lockfiles).
- Run `/clear` between unrelated tasks instead of continuing one session.
- Manual `/compact "preserve: <key decisions, files touched, open questions>"` at ~80% before auto triggers.
- Route to Haiku for lookups/formatting, Sonnet for edits, Opus only for multi-file reasoning.
- Use a CLI proxy (e.g., "RTK" Rust Token Killer) to compress tool output (`cargo test` 155→3 lines). [kilocode discussion](https://github.com/Kilo-Org/kilocode/discussions/5848)
- "Caveman" skill — instruct agent to respond in telegraphic short sentences; measurable savings. [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- One task per session / one session per git worktree.
- Use subagents specifically to keep grep-bomb output out of the parent context.

## Hook / skill / agent recipes spotted

- **SessionStart: load context.** `git status --short && grep -r 'TODO:' src/ | head -20` piped to stdout, gets injected as context. [claudefast](https://claudefa.st/blog/tools/hooks/session-lifecycle-hooks)
- **PostToolUse: format + test.** Trigger Prettier/Black/ruff on Edit tool; run targeted `pytest`/`npm test` on changed files. Most-cited recipe. [eesel](https://www.eesel.ai/blog/hooks-in-claude-code)
- **PreToolUse: rm-rf guard.** Exit 2 on any Bash input matching `rm\s+-[rf]+\s+(/|~|\*|\.\.)`. Born from the Wolak incident. [issue #10077](https://github.com/anthropics/claude-code/issues/10077)
- **SubagentStop: queue pump.** Hook reads `.claude/queue.txt`, prints next "Use X subagent on Y"; parent executes. Enables pseudo-chaining. [#5812](https://github.com/anthropics/claude-code/issues/5812)
- **Stop: ship-it log.** Append completion summary to `~/work.log` or post to Slack. [ksred guide](https://www.ksred.com/claude-code-hooks-a-complete-guide-to-automating-your-ai-coding-workflow/)
- **Skill design pattern**: SKILL.md frontmatter `description:` must contain "Use when X. Do not use when Y." Progressive disclosure: SKILL.md stays <500 tokens, pulls deeper scripts/templates from same dir on demand. [Anthropic docs cited by community](https://code.claude.com/docs/en/skills)
- **Code-review skill** and **frontend-design skill** repeatedly top "must-install" lists. [unicodeveloper](https://medium.com/@unicodeveloper/10-must-have-skills-for-claude-and-any-coding-agent-in-2026-b5451b013051)

## Horror stories (what went wrong)

- **`rm -rf ~/` expansion (Dec 2025, r/ClaudeAI)**: Claude produced `rm -rf tests/ patches/ plan/ ~/`; the trailing `~/` nuked the Mac home dir. No `--dangerously-skip-permissions` needed in a related WSL case. [issue #10077](https://github.com/anthropics/claude-code/issues/10077) · [simonw thread](https://x.com/simonw/status/1998447540916936947)
- **Production DB wiped (r/vibecoding → r/ClaudeAI crosspost)**: Agent "chose the nuclear option" and dropped production data; apologized after. [Paweł Huryn summary](https://x.com/PawelHuryn/status/1959183028539867587)
- **Claude Code source-code leak (Mar 31 2026)**: Misconfigured .npmignore shipped full source via .map files; 41K+ forks before takedown. Huge r/LocalLLaMA + r/ClaudeAI thread. [dev.to recap](https://dev.to/varshithvhegde/the-great-claude-code-leak-of-2026-accident-incompetence-or-the-best-pr-stunt-in-ai-history-3igm)
- **Cache bugs silently 10–20x-ing API bills**: Reported repeatedly on r/ClaudeAI; some users only noticed via billing spike. [aicodingdaily recap](https://aicodingdaily.substack.com/p/token-limits-horror-leaked-claude)
- **Auto-compact mid-refactor → "Claude forgot everything"**: Specific variable names and earlier decisions collapsed into mush; quality nose-dive. [#13112](https://github.com/anthropics/claude-code/issues/13112)

## Promising repos for deep-dive

- [anthropics/claude-code](https://github.com/anthropics/claude-code) — canonical SKILL.md examples in `plugins/plugin-dev/skills/`.
- [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) — hook recipe library, heavily upvoted.
- [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips) — 45 tips; status line, skill examples, Gemini-as-minion pattern.
- [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) — 100+ specialist subagent definitions.
- [wshobson/agents](https://github.com/wshobson/agents) — multi-agent orchestration framework.
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) — curated skill index incl. caveman, code-review, frontend-design.
- [rosaboyle/awesome-cc-oss](https://github.com/rosaboyle/awesome-cc-oss) — umbrella list with horror-story context.
- [jeremylongshore/claude-code-plugins-plus-skills](https://github.com/jeremylongshore/claude-code-plugins-plus-skills) — ccpi CLI package manager for skills/plugins.
- [kivilaid/plugin-marketplace](https://github.com/kivilaid/plugin-marketplace) — reference marketplace showing every component type.
- [zhsama/claude-sub-agent](https://github.com/zhsama/claude-sub-agent) — sub-agent-native dev workflow system.
- [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill) — research-across-socials skill, useful template for the playbook's own research agents.

---

Caveats: direct reddit.com WebFetch was blocked in this agent's environment; findings rely on search-index summaries of Reddit threads and third-party recaps that quote them. Where exact permalinks were returned by search they are cited; otherwise the most-credible proxy is labeled "(proxy)". Signal quality is high on themes consistently echoed across 3+ sources.
