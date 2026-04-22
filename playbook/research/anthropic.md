# Anthropic Scout — Report

Researched 2026-04-22 against `code.claude.com/docs/en/*` (the new canonical home for Claude Code docs; `docs.claude.com/en/docs/claude-code/*` now 301s here), `platform.claude.com` (Agent SDK + release notes), the anthropic.com engineering blog, and the anthropics/claude-code CHANGELOG.

## Official guidance map

| Page | URL |
|---|---|
| Skills | https://code.claude.com/docs/en/skills |
| Subagents | https://code.claude.com/docs/en/sub-agents |
| Hooks | https://code.claude.com/docs/en/hooks |
| Plugins (authoring) | https://code.claude.com/docs/en/plugins |
| Plugins reference | https://code.claude.com/docs/en/plugins-reference |
| Commands (built-ins + bundled skills) | https://code.claude.com/docs/en/commands |
| Settings | https://code.claude.com/docs/en/settings |
| Permissions | https://code.claude.com/docs/en/permissions |
| Memory / CLAUDE.md | https://code.claude.com/docs/en/memory |
| Output styles | https://code.claude.com/docs/en/output-styles |
| Context window | https://code.claude.com/docs/en/context-window |
| MCP | https://code.claude.com/docs/en/mcp |
| Debug your config | https://code.claude.com/docs/en/debug-your-config |
| Agent SDK overview | https://platform.claude.com/docs/en/api/agent-sdk/overview |
| Release notes / CHANGELOG | https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md |
| Engineering: Agent Skills | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills |
| News: Introducing Agent Skills (2025-12-18) | https://www.anthropic.com/news/skills |
| llms.txt doc index | https://code.claude.com/docs/llms.txt |

## Canonical patterns (Anthropic-sanctioned)

1. **Progressive disclosure for Skills** — `SKILL.md` stays small; supporting files load on demand. "Keep `SKILL.md` under 500 lines." (skills § Add supporting files).
2. **Front-load the description** — combined `description` + `when_to_use` is truncated at 1,536 chars in the skill listing; put the trigger keywords first (skills § Frontmatter reference).
3. **Separate facts (CLAUDE.md) from procedures (skills)** — "If an entry is a multi-step procedure or only matters for one part of the codebase, move it to a skill or a path-scoped rule" (memory § When to add to CLAUDE.md). Target <200 lines per CLAUDE.md.
4. **Path-scoped rules** — `.claude/rules/*.md` with `paths:` frontmatter load only when Claude touches matching files; use instead of a giant CLAUDE.md (memory § Organize rules with `.claude/rules/`).
5. **Subagents for context isolation** — spawn when "a side task would flood your main conversation with search results, logs, or file contents you won't reference again" (sub-agents, intro).
6. **Fork-context skills** — `context: fork` + `agent: Explore|Plan|general-purpose` turns a skill into an isolated research/planning run; SKILL.md body becomes the task prompt (skills § Run skills in a subagent).
7. **`disable-model-invocation: true` for side-effecting commands** — `/commit`, `/deploy`, `/send-slack-message` should not auto-trigger (skills § Control who invokes a skill).
8. **Hooks for deterministic enforcement** — "If a skill seems to stop influencing behavior … use hooks to enforce behavior deterministically" (skills § Skill content lifecycle).
9. **Permissions precedence: deny → ask → allow**, first match wins; array settings merge across scopes (settings).
10. **Plugins for sharing**, standalone `.claude/` for personal/experimental. Plugin skills are auto-namespaced `plugin-name:skill-name` (plugins § When to use plugins vs standalone).
11. **Pre-approve tools via `allowed-tools` in frontmatter**, not via global allow rules you'll forget about (skills § Pre-approve tools for a skill).
12. **Inject dynamic context with `` !`cmd` ``** — shell output is substituted into the prompt before Claude sees it; ideal for PR/issue context (skills § Inject dynamic context).

## Skills — what Anthropic says to do

- A skill is a directory with a required `SKILL.md` (YAML frontmatter + markdown body). Folder name = slash-command name (skills § Getting started).
- Locations, highest precedence first: enterprise managed → `~/.claude/skills/` → project `.claude/skills/` → plugin `plugin/skills/` (namespaced). Nested `.claude/skills/` inside monorepo packages are auto-discovered. `--add-dir` is the one exception that loads skills but nothing else.
- **Frontmatter fields** (all optional; only `description` recommended): `name`, `description`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `model`, `effort` (`low`/`medium`/`high`/`xhigh`/`max`), `context: fork`, `agent`, `hooks`, `paths`, `shell`.
- **Progressive disclosure**: only name + description (≤1,536 chars) stay in context; full body loads only when invoked. Auto-compaction re-attaches the most-recent invocation of each skill, first 5,000 tokens each, shared 25,000-token budget (skills § Skill content lifecycle).
- **Activation triggers**: natural-language match against `description`/`when_to_use`; optional `paths:` glob gating; explicit `/skill-name` invocation; or preload into a subagent.
- **Skills vs subagents**: skill = reusable prompt/procedure in current context; subagent = new context window + its own tools. `context: fork` combines both (skill body as task, agent config as environment). Official guidance: reach for a skill first, escalate to subagent only when you need isolation or a different tool set.
- **Argument substitution**: `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`, `$name` (with `arguments:` frontmatter), plus `${CLAUDE_SESSION_ID}`, `${CLAUDE_SKILL_DIR}`.
- Extended thinking: include the word "ultrathink" anywhere in the skill body (skills § Inject dynamic context Tip).
- `.claude/commands/*.md` still works but skills are the recommended format; a skill wins over a same-named command. Skills follow the open Agent Skills standard (agentskills.io), with Claude-Code-specific extensions.

## Subagents — what Anthropic says to do

- Each subagent runs in its own context window with a custom system prompt, tool allowlist, and permissions (sub-agents intro).
- Use for: preserving parent context, enforcing tool constraints, reusing a worker, specializing behavior, routing cheap work to Haiku.
- Parent/child boundary: parent only sees the subagent's summary message. Subagents do not see the parent's history unless content is explicitly passed in the delegation prompt.
- Built-in agents: `Explore` (read-only research), `Plan` (planning mode), `general-purpose` (default). Custom agents live in `.claude/agents/<name>.md`.
- Agents can preload skills via `skills:` frontmatter (full skill body injected at startup, unlike main session where only the description loads) — see sub-agents § Preload skills into subagents.
- Subagents can keep their own auto-memory (see memory page).
- For cross-session / multi-participant coordination, use **Agent Teams** (separate feature); subagents stay within one session.

## Hooks — what Anthropic says to do

Full event list from the hooks page (April 2026):

- **SessionStart** — load context / set env vars at session start or resume.
- **SessionEnd** — cleanup; final-state logging.
- **UserPromptSubmit** — validate/block/augment the user prompt before Claude sees it.
- **UserPromptExpansion** — block or modify slash-command expansions.
- **PreToolUse** — allow / deny / ask / defer a tool call; may rewrite `tool_input`.
- **PermissionRequest** — allow/deny the permission dialog programmatically.
- **PermissionDenied** — log auto-mode denials; can set `retry: true`.
- **PostToolUse** — run lints/validators/loggers after successful tool calls; can `decision: block` to feed error back to Claude.
- **PostToolUseFailure** — react to failed tool calls; add corrective context.
- **Stop** — run at end of Claude turn; `decision: block` forces Claude to continue.
- **StopFailure** — log API-error turn ends (rate limit, auth, billing).
- **Notification** — react to permission prompts / idle / auth / elicitation UI.
- **SubagentStart / SubagentStop** — lifecycle hooks for spawned subagents.
- **TaskCreated / TaskCompleted** — validate task-tool lifecycle.
- **TeammateIdle** — prevent agent-team teammates from going idle.
- **InstructionsLoaded** — audit when CLAUDE.md / `.claude/rules/*.md` load.
- **ConfigChange** — audit/validate settings changes.
- **CwdChanged** — react to `cd` (direnv-style env injection).
- **FileChanged** — react to watched file changes.
- **WorktreeCreate / WorktreeRemove** — override git-worktree lifecycle.
- **PreCompact / PostCompact** — block or observe context compaction.
- **Elicitation / ElicitationResult** — handle MCP server input dialogs.

Handler types: `command` (stdin JSON, exit 2 = block), `http`, `prompt` (sub-LLM), `agent` (experimental). Fields include `matcher` (string, `|` list, or regex), `if` (permission-rule syntax like `Bash(git *)`), `timeout`, `async`, `statusMessage`. Exit 2 blocks; stdout JSON with `decision` / `permissionDecision` / `hookSpecificOutput` is the richer API. Skill- and agent-scoped hooks go in frontmatter (`hooks:`); global hooks live in `settings.json`. `CLAUDE_ENV_FILE` lets SessionStart/CwdChanged/FileChanged export env vars for subsequent Bash calls.

## Plugins / Marketplaces

- **Plugins are the official distribution mechanism** (plugins § When to use plugins vs standalone). A plugin is a directory with `.claude-plugin/plugin.json`. Components go at plugin root: `skills/`, `agents/`, `commands/`, `hooks/hooks.json`, `.mcp.json`, `.lsp.json`, `monitors/monitors.json`, `bin/`, `settings.json`.
- Dev loop: `claude --plugin-dir ./my-plugin`, then `/reload-plugins` on change. `--plugin-dir` overrides same-named installed plugins.
- Plugins can bundle **LSP servers** (real-time code intelligence) and **background monitors** (tail logs → notifications) — both relatively new primitives.
- Plugin `settings.json` currently supports only `agent` (activate a bundled subagent as the main thread) and `subagentStatusLine`.
- Marketplaces: install/browse via `/plugin`. Submit to the official Anthropic marketplace at claude.ai/settings/plugins/submit or platform.claude.com/plugins/submit. Organizations enforce allowlists via `strictKnownMarketplaces` / `blockedMarketplaces` in managed settings.

## Changelog highlights (v2.0 → current)

From `anthropics/claude-code` CHANGELOG and release-notes redirect (summarized — exact versions visible in the raw file):

- **Skills launched as GA product** (2025-12-18, news/skills + engineering post). Merged custom commands into skills; `.claude/commands/*.md` still works, `.claude/skills/<name>/SKILL.md` is preferred.
- **Agent Teams** — multi-session multi-user collaboration, distinct from in-session subagents.
- **Auto memory** (v2.1.59+) — Claude writes `~/.claude/projects/<project>/memory/MEMORY.md` itself; first 200 lines / 25 KB loaded per session.
- **Hook surface area expanded** to ~25 events including `PreCompact` / `PostCompact`, `CwdChanged`, `FileChanged`, `Elicitation`, `TeammateIdle`, `PermissionRequest`.
- **Plugins** gained LSP servers, background monitors, `settings.json` with `agent` key, `${CLAUDE_PLUGIN_DATA}` for persistent state.
- **Checkpoints / rewind** — session rewind to prior tool-call states (docs page referenced from features-overview; exact URL moving).
- **1M-token context** for Opus 4.6 on Max/Team/Enterprise.
- **Output styles** (Default, Explanatory, Learning) plus custom user/project styles shippable via plugins.
- **MCP** — OAuth refresh, elicitation, per-tool `_meta["anthropic/maxResultSizeChars"]`.
- **New-style `/init`** behind `CLAUDE_CODE_NEW_INIT=1` — multi-phase interactive scaffolding with subagent exploration.

## Gotchas Anthropic explicitly calls out

- **Skill descriptions get truncated** at 1,536 chars and the overall skill listing is budgeted at 1% of the context window (fallback 8,000 chars, raise via `SLASH_COMMAND_TOOL_CHAR_BUDGET`); bad descriptions = skill never triggers (skills § Skill descriptions are cut short).
- **`context: fork` with non-task content is useless** — a "style guide" skill with no action will run, produce nothing, and return (skills Warning box).
- **CLAUDE.md is a user message, not system prompt** — Claude may disobey; use `--append-system-prompt` or a hook for hard enforcement (memory § Claude isn't following my CLAUDE.md).
- **Nested CLAUDE.md files do not re-inject after `/compact`** — only project-root CLAUDE.md does.
- **`--add-dir` grants file access but not config discovery** — exception: `.claude/skills/` inside added dirs is loaded; agents, commands, output-styles are **not** (permissions § exceptions table).
- **`user-invocable: false` hides from menu but not from Skill tool** — to truly block Claude, use `disable-model-invocation: true` or a `Skill(name)` deny rule.
- **Plugin structure trap**: only `plugin.json` goes inside `.claude-plugin/`; `skills/`, `agents/`, `commands/`, `hooks/` must sit at plugin root (plugins Warning box).
- **After compaction, older skills can be dropped entirely** if many were invoked; re-invoke the important one (skills § Skill content lifecycle).
- **Skill body is injected once as a single message** and is not re-read on later turns — write it as standing instructions, not one-time steps.
- **`allowed-tools` only pre-approves** — it does not restrict. Use `permissions.deny` to actually block.

## Promising repos for deep-dive

- **anthropics/claude-code** (GitHub) — CHANGELOG is the single best authoritative timeline. Issues track known bugs. No public source for the CLI itself.
- **anthropics/claude-agent-sdk-python** and **anthropics/claude-agent-sdk-typescript** — SDK used to embed Claude-Code-style agents in your own apps; primitives mirror Claude Code (skills, hooks, tools). Examples folder is the best practical reference.
- **anthropics/skills** — official public skills repo (Excel, PowerPoint, PDF, Word document skills referenced in the news/skills post). Read every `SKILL.md` for idiomatic style.
- **anthropics/anthropic-cookbook** — general Claude API cookbook; the `agents/` and `tool_use/` notebooks pair well with the Agent SDK.
- **agentskills.io** — open-standard spec Skills conform to; useful when designing skills intended to work in both Claude Code and other hosts.

Deep-dive priority if you only read one thing: `anthropics/skills` examples + the Skills doc page. They encode the Anthropic house style (tight description, progressive disclosure via supporting files, scripts over inlined code) more concretely than prose ever will.
