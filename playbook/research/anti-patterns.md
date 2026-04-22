# Anti-Pattern Scout — Report

Scope: patterns practitioners regret with Claude Code (as of 2026-04-22). Every claim is paraphrased and sourced.

## Top anti-patterns (ranked by damage)

1. **PostToolUse hook that re-invokes Claude (infinite loop)** — Symptom: one user misconfig triggered 25 auto-runs in a row, most zero-minute sessions with a couple of tool calls; tokens burn and system can hang. Why it fails: PostToolUse fires on the *agent's* own tool calls, not just the user's — the hook calls Claude, Claude uses a tool, hook fires again. Sub-agents inherit the same hook, multiplying the blast radius. Avoid: add a session-ID or execution-flag guard; never have a PostToolUse hook spawn another Claude; test hooks in a sandbox first. Sources: [dev.to post-mortem](https://dev.to/ji_ai/writing-a-claude-code-book-with-claude-code-when-posttooluse-hooks-loop-25-times-4h46), [GH #10205](https://github.com/anthropics/claude-code/issues/10205), [claude-flow #427](https://github.com/ruvnet/claude-flow/issues/427).

2. **MCP tool bloat (50+ tools loaded at startup)** — Symptom: 66k+ tokens consumed before the first prompt; context exhausts after ~5 prompts; tool-selection accuracy drops, parameter hallucinations rise. Why: every enabled MCP server's tool defs go in the system prompt; with ~20 servers running, 1/3 of a 200k window is gone up front. Avoid: disable unused servers (v2.0.10+), use MCP Tool Search (on-demand discovery — ~8.7k vs ~77k tokens), keep one MCP per project not per machine. Sources: [GH #3036](https://github.com/anthropics/claude-code/issues/3036), [GH #7328 tool filtering](https://github.com/anthropics/claude-code/issues/7328), [GH #12241](https://github.com/anthropics/claude-code/issues/12241), [Scott Spence](https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code), [MCP Tool Search overview](https://claudefa.st/blog/tools/mcp-extensions/mcp-tool-search).

3. **CLAUDE.md bloat / context rot** — Symptom: model seems "dumber," skips instructions, loses focus on the actual task. Why: CLAUDE.md loads every session; long-context research shows middle-of-context info is handled worst, so a 10k-token CLAUDE.md still degrades even inside the window. An auto-update (2.1.110→2.1.111) once pushed startup usage from 8%→22% on unchanged projects, confirming sensitivity. Avoid: progressive disclosure — short pointer file that imports more detail only on demand; audit and prune monthly. Sources: [alexop.dev](https://alexop.dev/posts/stop-bloating-your-claude-md-progressive-disclosure-ai-coding-tools/), [MindStudio context rot](https://www.mindstudio.ai/blog/context-rot-claude-code-skills-bloated-files), [GH #49593](https://github.com/anthropics/claude-code/issues/49593), [GH #29971](https://github.com/anthropics/claude-code/issues/29971).

4. **Opus-for-everything (or Haiku-for-real-dev)** — Symptom: surprise invoice; or endless retries on logic Haiku can't handle. Why: Opus ≈ 5× Sonnet cost; same task $0.10 Haiku / $1.20 Sonnet / $6.00 Opus. Haiku chokes on multi-file reasoning. Avoid: `opusplan` (Opus plans, Sonnet executes) saves 60–80%; default to Sonnet; reserve Haiku for mechanical work (renames, formatting, boilerplate). Source: [claudefa.st model selection](https://claudefa.st/blog/models/model-selection).

5. **Subagent over-spawning (Opus 4.6 tendency)** — Symptom: multi-agent runs burn 4–7× tokens, Agent Teams ~15×; parent loses track; "invocation failures" from vague delegation. Why: Anthropic's own docs flag Opus as eager to delegate even when direct work is faster. Nested spawning compounds costs and makes state hard to reason about. Avoid: flat hierarchy (one orchestrator, one sub-agent layer); 2–3 parallel info-gathering agents max; explicit routing rules in CLAUDE.md; each sub-agent gets a clear deliverable. Sources: [claudefa.st sub-agents](https://claudefa.st/blog/guide/agents/sub-agent-best-practices), [Medium delegation guide](https://medium.com/@richardhightower/claude-code-subagents-and-main-agent-coordination-a-complete-guide-to-ai-agent-delegation-patterns-a4f88ae8f46c).

6. **`--dangerously-skip-permissions` outside a sandbox** — Symptom: 32% of users hit at least one unintended file modification; 9% reported data loss (eesel AI survey, cited by Anthropic's auto-mode post). Avoid: prefer Auto Mode (classifier-gated approvals) or a container sandbox; never on a machine with credentials or uncommitted work. Sources: [Anthropic auto-mode](https://www.anthropic.com/engineering/claude-code-auto-mode), [truefoundry](https://www.truefoundry.com/blog/claude-code-dangerously-skip-permissions).

7. **Self-review feedback loops (agent grading its own homework)** — Symptom: tests "pass" but test the wrong thing; every PR looks fine individually, yet after 10 steps the project is somewhere nobody intended; reviewers click-through approve by the 10th iteration. Why: auto-approve + same-agent review removes the falsifier. Avoid: separate review subagent with critical-mindset prompt; review test *cases*, not just results; `hamelsmu/claude-review-loop` pattern uses Codex as the independent reviewer. Sources: [paddo.dev core loop](https://paddo.dev/blog/stop-speedrunning-claude-code/), [dev.to broke CI in 30m](https://dev.to/kenimo49/i-turned-on-auto-approve-in-claude-code-and-broke-ci-in-30-minutes-1g1a), [claude-review-loop](https://github.com/hamelsmu/claude-review-loop).

8. **Correction spiral instead of `/clear`** — Symptom: two failed corrections, context now full of wrong approaches, every further attempt inherits the confusion. Avoid: if you've corrected the plan twice, abort — `/clear` and rewrite the prompt with what you learned. Source: [datacamp best practices](https://www.datacamp.com/tutorial/claude-code-best-practices).

9. **Skipping plan mode on architectural work** — Symptom: "add soft deletes" → 14 files modified, global query filter breaks endpoints, migration history conflicts. Why: without a plan, Claude makes locally-optimal decisions that are globally terrible. Avoid: plan mode for anything multi-file; skip it only for known-localized bug fixes. Source: [claudefluent plan mode](https://www.claudefluent.com/guides/claude-code-plan-mode).

10. **"Git-repo-as-marketplace"** — Symptom: no version pinning, no managed-settings enforcement, silent breakage on update; marketplace skills sometimes not exposed via Skill tool at all. Avoid: real `marketplace.json`, pinned versions, don't trust plugins you haven't read (no binary signing as of 2026). Sources: [mpt.solutions](https://www.mpt.solutions/your-claude-plugin-marketplace-needs-more-than-a-git-repo/), [GH #10568](https://github.com/anthropics/claude-code/issues/10568).

## CLAUDE.md bloat — specific tells

- Over ~2k tokens / ~500 lines (progressive disclosure becomes mandatory past that).
- Restates language/framework basics Claude already knows.
- Duplicates content also present in a skill or README.
- Long "dos and don'ts" lists with no examples — model skims them.
- Pasted stack traces or sample outputs from past sessions.
- Instructions for one-off past tasks never cleaned up.
- Startup context usage > ~15% before any work begins ([GH #49593](https://github.com/anthropics/claude-code/issues/49593)).
- Middle-of-file instructions get ignored — classic "lost in the middle."

## MCP bloat — specific tells

- More than ~15 MCP tools visible in `/mcp`.
- Context gauge > 20% at session start with no task loaded.
- Claude picks the wrong tool for a known operation, or hallucinates params.
- You have servers enabled you haven't used in a week.
- Multiple overlapping servers (e.g., two GitHub MCPs) — seen in this very session.
- Latency rises noticeably on the first turn.
- Token overhead visible in `/cost` before any user prompt.
  Sources: [MindStudio MCP overhead](https://www.mindstudio.ai/blog/claude-code-mcp-server-token-overhead-2), [atcyrus](https://www.atcyrus.com/stories/mcp-tool-search-claude-code-context-pollution-guide).

## Hook failure modes

- **PostToolUse recursion** — hook triggers agent which triggers hook ([dev.to](https://dev.to/ji_ai/writing-a-claude-code-book-with-claude-code-when-posttooluse-hooks-loop-25-times-4h46)).
- **Sub-agent hook inheritance** — parent's hooks run inside every spawned child, multiplying side effects ([egghead](https://egghead.io/avoid-the-dangers-of-settings-pollution-in-subagents-hooks-and-scripts~xrecv)).
- **SessionStart phantom errors** — hook exits 0 but UI shows "hook error" because stderr is interpreted as failure ([GH #12671](https://github.com/anthropics/claude-code/issues/12671), [claude-mem #1181](https://github.com/thedotmack/claude-mem/issues/1181)).
- **Windows .sh/.cmd mis-dispatch** — 2.1.x prepends `bash` to `.cmd` files, hooks silently never run ([GH #21468](https://github.com/anthropics/claude-code/issues/21468), [superpowers #383](https://github.com/obra/superpowers/issues/383)).
- **Race conditions with worker services** — hook fires before dependency accepts connections ([claude-mem #775](https://github.com/thedotmack/claude-mem/issues/775)).
- **SessionStart output never injected on new conversations** — only works on `/clear`/`/compact`/resume ([GH #10373](https://github.com/anthropics/claude-code/issues/10373)).

## Subagent misuse

- **Nested spawning** — sub-agent spawns sub-agent, parent can't track state.
- **Vague delegation** — "look into this" without deliverable; sub-agent wastes tokens exploring.
- **Parallel when sequential needed** — two agents editing related files race.
- **Opus over-delegation** — Opus 4.6 delegates even when direct work is cheaper/faster.
- **No context budget** — sub-agent's 200k window is independent; orchestrator summary has to fit back.
- **Same-model review** — review agent and author agent are same model, same blind spots.
  Sources: [claudefa.st sub-agents](https://claudefa.st/blog/guide/agents/sub-agent-best-practices).

## Cost / token-spend traps

- **Opus as default** — 5× Sonnet for most tasks ([claudefa.st](https://claudefa.st/blog/models/model-selection)).
- **Verbosity tax** — politeness/preamble tokens measurably consume quota; "Caveman mode" community hack cut usage ~75% ([Caveman mode](https://www.nathanonn.com/claude-code-caveman-mode/)).
- **Cache invalidation bugs** silently cost 10–20× ([aicodingdaily](https://aicodingdaily.substack.com/p/token-limits-horror-leaked-claude)).
- **Agent Teams at 15× baseline** — easy to leave running.
- **MCP server tool defs** — billed every turn even if unused.
- **Long sessions without `/compact`** — prior failed attempts keep costing on every turn.
- **Auto-retry loops** without circuit-breakers in custom harnesses.

## Promising repos for deep-dive

- [anthropics/claude-code issues](https://github.com/anthropics/claude-code/issues) — filter `label:bug` for real-world failure modes; #10205 (hook loops), #49593 (context bloat regression), #12241 (MCP warning), #21468 (Windows hooks) are representative.
- [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) — documents hook pitfalls alongside patterns.
- [hamelsmu/claude-review-loop](https://github.com/hamelsmu/claude-review-loop) — Codex-as-independent-reviewer to break self-approval loops.
- [obra/superpowers issues](https://github.com/obra/superpowers/issues) — #275, #383 detail SessionStart hook failures with reproductions.
- [thedotmack/claude-mem issues](https://github.com/thedotmack/claude-mem/issues) — #775, #1181 show stderr/race-condition hook gotchas.
- [ruvnet/claude-flow #427](https://github.com/ruvnet/claude-flow/issues/427) — default hook config recursion risk analysis.
