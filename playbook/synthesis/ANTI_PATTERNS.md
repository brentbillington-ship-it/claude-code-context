# Anti-Patterns — What NOT to Do

Cross-referenced against all 8 Wave 1 reports. Reasoning plus source citations. Apply these as negative rules in CLAUDE_CODE_STANDING_RULES.md or as hook allow/deny patterns.

---

## A1. Never write a PostToolUse hook that invokes Claude

**Failure:** Infinite loop. Claude's tool call → hook runs → hook calls Claude → Claude makes a tool call → hook runs again. Reports of 25 auto-runs burning tokens in a row.

**Why:** PostToolUse fires on the *agent's* own tool calls, not the user's. Subagents inherit the hook, multiplying blast radius.

**Rule:** PostToolUse hooks must be idempotent and non-recursive. If you need agent-driven reaction to tool use, use a skill, not a hook. If you must, add a session-ID or execution-count guard.

*Source: `anti-patterns.md` #1.*

---

## A2. Never enable more than ~15 MCP tools at once

**Failure:** 66k+ tokens consumed before the first prompt. Context exhausts after ~5 turns. Tool-selection accuracy drops, parameter hallucinations rise.

**Why:** MCP tool definitions are billed every turn.

**Rule:** Enable MCP servers per-project in `.claude/settings.json`, not user-global. Audit `/mcp` output monthly. MCP Tool Search (on-demand discovery) cuts 77k → 8.7k.

*Source: `anti-patterns.md` #2, `tools.md` token-budget math.*

---

## A3. Never let CLAUDE.md grow past 200 lines / 2k tokens

**Failure:** Startup context usage climbs over 15% with no work loaded. Middle-of-file instructions get ignored ("lost in the middle"). Model seems "dumber," skips rules.

**Why:** CLAUDE.md loads every session; long-context research shows middle-of-context is handled worst.

**Rule:** 200-line hard cap. Critical rules in first 5 and last 5 lines. Move details to skills or path-scoped rules. Audit monthly. Positive framing only ("MUST use X"), not negatives with examples.

*Source: `anti-patterns.md` #3, `reddit.md` signal #1, `anthropic.md` (memory page).*

---

## A4. Never default to Opus for everything

**Failure:** Surprise invoice. Opus ≈ 5× Sonnet cost; Opus 4.7 burns 1.5–3× more tokens than 4.6 on ambiguous prompts (ambiguity tax).

**Why:** Community ratio is ~80/20 Sonnet/Opus for production. Haiku for mechanical work (renames, formatting, boilerplate).

**Rule:** Default = Sonnet. Opus only for: architecture decisions, multi-file refactors, cross-module reasoning. Haiku for: formatting, lookups, renames. `opusplan` (Opus plans, Sonnet executes) saves 60–80%.

*Source: `anti-patterns.md` #4, `reddit.md` signal #6.*

---

## A5. Never use `--dangerously-skip-permissions` outside a container/VM

**Failure:** Real incident: Claude produced `rm -rf tests/ patches/ plan/ ~/`; the trailing `~/` wiped the Mac home dir. 32% of users hit at least one unintended file modification; 9% reported data loss.

**Why:** Claude is a user message model — it will obey a context-rotted prompt. The flag removes the last falsifier.

**Rule:** Prefer Auto Mode (classifier-gated approvals). Use a Trail of Bits devcontainer if you truly need YOLO. Never on a machine with credentials or uncommitted work. Add a PreToolUse Bash hook that blocks `rm\s+-[rf]+\s+(/|~|\*|\.\.)` regardless.

*Source: `anti-patterns.md` #6, `reddit.md` signal #8 + horror stories.*

---

## A6. Never let the same model review its own code

**Failure:** Tests "pass" but test the wrong thing. Every PR looks fine individually; after 10 steps the project is somewhere nobody intended.

**Why:** Self-approval bias. Same blind spots.

**Rule:** Reviewer subagent must be a *different model* (`hamelsmu/claude-review-loop` uses Codex). At minimum, reviewer must have a critical-mindset prompt + review test cases, not just results.

*Source: `anti-patterns.md` #7, `hn.md` (Code Review thread).*

---

## A7. Never correction-spiral — `/clear` instead

**Failure:** Two failed corrections; context is now full of wrong approaches. Every subsequent attempt inherits the confusion.

**Why:** Context rot compounds. The agent's "memory" of what didn't work becomes noise.

**Rule:** Hard rule — if the third prompt in a session starts with "no, I meant…," stop, `/clear`, rewrite the prompt with what you learned. Two strikes and reset.

*Source: `anti-patterns.md` #8, `hn.md` restart-over-repair, `reddit.md` signal #9.*

---

## A8. Never skip Plan Mode on multi-file changes

**Failure:** "Add soft deletes" → 14 files modified, global query filter breaks endpoints, migration history conflicts.

**Why:** Without a plan, Claude makes locally-optimal decisions that are globally terrible.

**Rule:** Plan mode (shift-tab x2) before any multi-file change. Skip only for known-localized bug fixes. The plan is the spec; review it before auto-accepting edits.

*Source: `anti-patterns.md` #9, `practitioners.md` (Boris Cherny default).*

---

## A9. Never treat a git repo as a marketplace

**Failure:** No version pinning, no managed-settings enforcement, silent breakage on update. Marketplace skills sometimes not exposed via Skill tool at all.

**Why:** No binary signing in CC as of 2026. Plugins ship code that runs in your session.

**Rule:** Only install plugins from trusted marketplaces with real `marketplace.json` + pinned versions. Read the source of any plugin before enabling. `trailofbits/skills-curated` is the vetted baseline.

*Source: `anti-patterns.md` #10, `github.md` (red flags — marketplace proliferation).*

---

## A10. Never spawn nested subagents

**Failure:** Subagent A spawns subagent B. Parent can't track state. Orchestrator summary has to compress two levels of work into one message, losing information.

**Why:** Each subagent has its own 200k window that's independent of the parent. Nesting compounds context-isolation costs beyond their benefit.

**Rule:** Flat hierarchy only. One orchestrator, one subagent layer. 2–3 parallel info-gathering agents max. SubagentStop queue-pump pattern for sequential phases.

*Source: `anti-patterns.md` subagent misuse, `reddit.md` signal #4.*

---

## A11. Never leave SessionStart hooks printing to stderr

**Failure:** Hook exits 0 but UI shows "hook error" because stderr is interpreted as failure. Hook effectively disabled.

**Why:** Claude Code treats any stderr output as a signal.

**Rule:** All SessionStart (and other) hooks must redirect stderr to a log file or `/dev/null` unless you explicitly want the error visible. Test with `claude --debug` before shipping.

*Source: `anti-patterns.md` hook failure modes.*

---

## A12. Never trust high star counts on "awesome" repos

**Failure:** 40k-star repos that are curation farms with inflated counts; `.claude/` is empty; you copy a pattern that no one has actually used in production.

**Why:** Star-farming and viral growth inflate certain aggregator repos. Real substance lives in smaller, focused repos.

**Rule:** Before copying from a repo, verify: (1) actual `.claude/` directory with working files, (2) active commits in last 90 days, (3) real license (not CC-BY-NC-ND), (4) at least one issue thread showing real-world use.

*Source: `github.md` red flags, `hn.md` leak discussion.*

---

## A13. Never ship an agent without a retirement trigger

**Failure:** Repo accumulates orphan agents. Every session CC wonders whether to invoke any of them. Context burns on tool-selection.

**Why:** Agents without retirement triggers become zombie tooling. CCC's `AGENT_MANAGER.md` gets this right; most surveyed repos do not.

**Rule:** Every agent in the registry has a concrete retirement trigger. Audit quarterly. Delete retired agents — don't mark and keep.

*Source: existing CCC `AGENT_MANAGER.md` (already best-practice).*

---

## A14. Never put side-effecting slash commands behind auto-invocation

**Failure:** Claude triggers `/commit`, `/deploy`, `/send-slack-message` on a natural-language trigger that matched the skill description. You have a wrong commit or a duplicate deploy.

**Why:** Model-invocable skills can be auto-triggered by description match.

**Rule:** `disable-model-invocation: true` on any skill with side effects outside the repo (git push, external API write, message send). Keep them user-invocable only.

*Source: `anthropic.md` canonical patterns #7.*

---

## A15. Never use a shared CLAUDE.md for multiple clients

**Failure:** Rules and context from Client A's project leak into prompts about Client B's project. Compliance risk, trust risk.

**Why:** CLAUDE.md loads every session. Merging client contexts into one global file creates cross-engagement bleed.

**Rule:** `~/.claude/CLAUDE.md` is *yours* (stays with you, generic). Per-repo `.claude/CLAUDE.md` is *the client's* (ships with handoff). `./CLAUDE.local.md` is *your sandbox/creds* (gitignored). Never a shared file per client in global scope — use the profile switcher.

*Source: `freelancer.md` 3-tier pattern.*

---

## A16. Never assume a hook runs on Windows `.cmd` files the way it runs on `.sh`

**Failure:** CC 2.1.x prepends `bash` to `.cmd` files; hooks silently never run. You think your PreToolUse guard is active — it isn't.

**Why:** Platform dispatch bug.

**Rule:** Write hooks in Python or POSIX shell (`.sh`) with an explicit shebang. Verify by running them with `claude --debug`. If Windows is a target, test specifically on Windows before shipping.

*Source: `anti-patterns.md` hook failure modes, GH #21468.*

---

## A17. Never run Agent Teams casually

**Failure:** Agent Teams burn ~15× the tokens of a single session. Easy to leave running overnight.

**Why:** Multi-session multi-user = multi-context.

**Rule:** Agent Teams only for work that genuinely needs multi-participant coordination. Single-user should prefer subagents-within-session.

*Source: `anti-patterns.md` cost traps, `anthropic.md` changelog.*

---

## A18. Never commit plugins you haven't read

**Failure:** Plugin contains arbitrary code that runs in your session. No binary signing, no sandbox.

**Why:** CC plugin ecosystem is trust-on-first-use.

**Rule:** Read every plugin's hook scripts, settings.json, and any bundled MCP config before enabling. Pin versions. Prefer `trailofbits/skills-curated` or plugins from maintainers you know by reputation.

*Source: `anti-patterns.md` #10, `tools.md` marketplace section.*

---

## Cross-reference: anti-pattern → recommended fix

| Anti-pattern | Fix |
|---|---|
| A1 PostToolUse recursion | Hook template in `templates/hooks/` excludes recursive triggers |
| A2 MCP bloat | MCP_CATALOG ranks by token cost; project-scoped settings recommended |
| A3 CLAUDE.md bloat | 6 templates in `templates/claude-md/` all stay under 150 lines |
| A4 Opus everywhere | RECOMMENDATIONS.md #12 model-routing default = Sonnet |
| A5 YOLO outside container | Devcontainer recommendation #11 + rm-rf hook |
| A6 Self-review | Cross-model review recommendation #13 |
| A7 Correction spiral | Add rule to CLAUDE_CODE_STANDING_RULES.md; see proposal |
| A9 Untrusted marketplaces | trailofbits/skills-curated in MARKETPLACE_CATALOG |
| A10 Nested subagents | AGENT_MANAGER.md update proposal |
| A14 Side-effect auto-invocation | Every skill scaffold uses `disable-model-invocation: true` where appropriate |
| A15 Shared CLAUDE.md | claude-code-profiles recommendation #5 |
