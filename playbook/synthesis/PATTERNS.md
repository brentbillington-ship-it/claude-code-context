# Patterns — Cross-Source Synthesis

Recurring architectures and practices, cross-referenced against the 8 Wave 1 reports under `playbook/research/`. Each pattern names what it is, where it comes from, when it applies, and when it doesn't.

---

## 1. The Four-Role Mental Model
**Skills teach. Agents specialize. Hooks automate. Commands orchestrate.**

- Sources: `github.md` (diet103, ChrisWiles, shanraisshan), `anthropic.md` (skills vs subagents), `reddit.md` (preference order: Skills > Commands > Subagents > Plugins).
- When it applies: any non-trivial project where behavior needs to be specified repeatedly.
- When it doesn't: one-shot scripts, throwaway explorations.
- Failure mode: using an agent when a skill would do (token-expensive); using a hook when a skill would do (turns advisory into deterministic, harder to debug).

---

## 2. Progressive Disclosure (for Skills and CLAUDE.md)
Only the skill description (≤1,536 chars) sits in context; the body loads on invoke. CLAUDE.md should mirror this: pointers, not encyclopedias.

- Sources: `anthropic.md` (skills lifecycle), `reddit.md` (<200 lines / <2k tokens), `anti-patterns.md` (CLAUDE.md bloat + context rot).
- 500-line hard cap on `SKILL.md` bodies. Deeper content in sibling files.
- Critical rules go in the first 5 and last 5 lines of CLAUDE.md (middle gets "lost in the middle").
- Failure mode: long "dos and don'ts" lists without examples — the model skims them.

---

## 3. Deterministic Enforcement via Hooks, Advisory Guidance via Prompts
"If it must happen every time, it's a hook." CLAUDE.md is a user message, not a system prompt; Claude can disobey. Only hooks (exit 2 / `decision: block`) are deterministic.

- Sources: `reddit.md` (hook-vs-CLAUDE.md split), `anthropic.md` (Gotchas — memory), `github.md` (disler blocks dangerous cmds via hooks).
- Canonical hook uses: formatter on PostToolUse, secret-scan on PreToolUse, rm-rf guard on Bash, test gate on Stop.
- Failure mode: PostToolUse that invokes Claude → infinite loop (see ANTI_PATTERNS.md #1).

---

## 4. Research → Plan → Execute → Review → Ship
Plan mode (shift-tab x2) before any multi-file change. A reviewer agent (ideally cross-model) grades the work before merge. Learnings feed back into CLAUDE.md.

- Sources: `practitioners.md` (Boris Cherny default flow, Kieran Klaassen compound engineering), `hn.md` (restart-over-repair), `anti-patterns.md` (skipping plan mode = 14-file regression).
- Cross-model review is the key falsifier: Claude reviewing Claude = self-approval bias.
- `hamelsmu/claude-review-loop` uses Codex as the independent reviewer.

---

## 5. Subagents as Context Firewalls, Not Sequential Workers
Spawn a subagent when "a side task would flood your main conversation with search results, logs, or file contents you won't reference again." Parent only sees the summary.

- Sources: `anthropic.md` (sub-agents intro), `hn.md` (contrarian — subagents over-spawned), `reddit.md` (loved for parallel research, slow for sequential work).
- Best use: grep bombs, multi-file exploration, security scans, independent reviews.
- Failure mode: spawning for tasks that would fit in main context (cold-start cost > savings); nested spawning (parent loses track); same-model reviewer (blind spots inherited).

---

## 6. SubagentStop Queue Handoff (pseudo-chaining)
Subagents can't invoke each other. Workaround: a SubagentStop hook reads `.claude/queue.txt` and emits "Use the X subagent on Y" — parent executes it.

- Sources: `reddit.md` (#5812, #8093), `github.md` (glittercowboy has a real SubagentStop.sh), existing `AGENT_MANAGER.md` concept aligns.
- Apply when: the workflow has clear sequential phases (research → plan → execute → review → ship).
- Don't apply when: the phases are actually independent (run in parallel instead).

---

## 7. Compound Engineering / Self-Correcting Memory
Every bug, review, and fix permanently upgrades the system. The dominant version uses markdown ledgers or SQLite for learnings, surfaced via SessionStart hook.

- Sources: `practitioners.md` (Every, Kieran Klaassen), `github.md` (`rohitg00/pro-workflow`, `parcadei/Continuous-Claude-v3`, `centminmod/my-claude-code-setup`).
- Mechanism: `[LEARN]` block in Stop hook → appended to `learnings.md` or SQLite → re-injected at next SessionStart.
- The Reddit "make Claude edit its own CLAUDE.md after each mistake" tip is a lightweight version of this.
- Beats Claude's own compaction for long-running projects.

---

## 8. Model Routing as Primary Cost Lever
Roughly 80/20 Sonnet/Opus. Haiku for mechanical work. `opusplan` pattern (Opus plans, Sonnet executes) saves 60–80%.

- Sources: `anti-patterns.md` (#4), `reddit.md` (signal #6), `practitioners.md` (Armin on Sonnet + $100 Max; Boris always Opus disagreement).
- Ambiguity tax: Opus burns 1.5–3× more tokens than needed on lazily-scoped prompts.
- Haiku for: renames, formatting, boilerplate, lookups. Not multi-file reasoning.

---

## 9. Per-Client Context Isolation
Separate profile per active client, committed `.claude/settings.json` per repo, devcontainer for anything untrusted. Credentials and MCP servers never cross.

- Sources: `freelancer.md` (pegasusheavy/claude-code-profiles, trailofbits/claude-code-devcontainer, 3-tier CLAUDE.md).
- Profile switch = full sandbox (settings, MCP, CLAUDE.md, shell history).
- Project-scoped `settings.json` ships with handoff; personal `~/.claude/settings.json` holds global deny list.

---

## 10. HANDOFF.md as First-Class Deliverable
Every project ships with a structured handoff: goal, progress, what worked, what didn't (critical — failed approaches with reasons), next steps. Freelancers use it for client deliverables; solo devs use it for agent-to-agent continuity.

- Sources: `freelancer.md` (willseltzer/claude-handoff, abhishekray07/claude-md-templates), `github.md` (centminmod memory bank).
- `/handoff:create`, `/handoff:quick`, `/handoff:resume` slash commands are the reference.
- Pairs well with auto-README generator as the second deliverable.

---

## 11. Context Hygiene (Auto-Compact Discipline)
Disable auto-compact. Run manual `/compact "preserve: <decisions, files, open questions>"` at ~80%. When stuck, `/clear` and rewrite the prompt with what you learned — don't accumulate correction layers.

- Sources: `reddit.md` (signal #5, contradicts Anthropic), `hn.md` (restart-over-repair), `anti-patterns.md` (correction spiral).
- Contradicts Anthropic's default; widely cited as reclaiming ~33% of the window.
- Related: .claudeignore for `node_modules`, `.venv`, fixtures, lockfiles.

---

## 12. Description-First Skill Design
Skill auto-invocation fires on natural-language match against the `description` frontmatter (truncated to 1,536 chars). Generic descriptions never trigger. The canonical shape: "Use when X. Do not use when Y."

- Sources: `anthropic.md` (skills frontmatter), `reddit.md` (signal #7), `practitioners.md` (Thariq).
- Front-load trigger keywords in the first 200 chars.
- `disable-model-invocation: true` for side-effecting commands (`/commit`, `/deploy`).
- `context: fork` + `agent:` turns a skill into an isolated research/planning run.

---

## 13. Tight MCP Footprint
Every enabled MCP server's tool definitions are billed on every turn. Keep <15 tools visible in `/mcp`. Enable per-project in `.claude/settings.json`, not user-global. MCP Tool Search reduces 77k → 8.7k.

- Sources: `anti-patterns.md` (#2), `tools.md` (token budget math), `hn.md` (contrarian — MCP over-prescribed).
- Skills + shell escape hatch replace most MCP servers for single-dev setups.
- MCP's real strength is live data (GitHub, DB, Sheets) — not instructions.

---

## 14. Safety Gates in Hooks, Not Prompts
Block destructive shell commands, sensitive file access, force-pushes via PreToolUse hook — not by asking Claude nicely in CLAUDE.md. Regex allow/deny lists with exit 2 = block.

- Sources: `anti-patterns.md` (rm-rf horror stories), `github.md` (disler), `freelancer.md` (secret-scan for client credentials).
- Pattern list to block: `rm\s+-[rf]+\s+(/|~|\*|\.\.)`, `git push --force`, reads of `.env*|*.pem|*.key|secrets/**`.
- Ship as a reusable hook, attach to every client repo.

---

## 15. Transcripts as the Durable Artifact
Claude Code transcripts are the decision log. Simon Willison publishes them. Agencies store them for auditing. Freelancers attach them to deliverables as proof-of-work.

- Sources: `practitioners.md` (Simon Willison, simonw/claude-code-transcripts), `freelancer.md` (audit right in contracts).
- Use case for Billington Works: attach the transcript that produced the deliverable → higher trust, defensible if challenged.

---

## 16. Git Worktree Per Feature / Session
Parallel Claude sessions on the same repo without file collisions. Each worktree has its own branch, context, and agent. `claude --worktree <name>` + tmux is the reference setup.

- Sources: `reddit.md` (signal #10), `hn.md` (creator workflow), `practitioners.md` (Boris Cherny's 5 tabs).
- Pairs with headless `-p` mode for batch manifests.
- Single-dev fit: overkill for most Billington Works projects; keep in reserve for big refactors.

---

## 17. Transparent, Non-Promoted AI Disclosure
Don't lead with "AI-built" in portfolios (pushes rates down). Do disclose honestly if asked or contractually required. Answer clients with specifics: "Claude writes ~60% of boilerplate under my direction; I do architecture, review, testing."

- Source: `freelancer.md` (mainstream indie consensus).
- Applies to Billington Works sales pages and case studies.

---

## 18. The "Throw Away and Restart" Rule
Two failed corrections = abort. `/clear`, rewrite the prompt with what you learned, start fresh. Context rot is irrecoverable; correction layers always get worse.

- Sources: `hn.md` (restart-over-repair), `reddit.md`, `anti-patterns.md` (#8).
- Hard rule: if the third prompt in a session starts with "no, I meant…," stop and restart.
