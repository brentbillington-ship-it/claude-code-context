# Slash Command Catalog

Commands worth adopting in `~/.claude/commands/` or per-project `.claude/commands/`.

Note: Anthropic now recommends `.claude/skills/<name>/SKILL.md` over `.claude/commands/<name>.md`. Skills win auto-invocation and can still be user-invoked like commands. Keep pure commands only for cases where no skill behavior is needed.

---

## Built-in (already present in CC 2.1+)

| Command | Purpose | When to use |
|---|---|---|
| `/init` | Scaffold CLAUDE.md | Per-project |
| `/compact` | Manual context compaction | At ~80% context, with `"preserve: …"` arg |
| `/clear` | Hard reset context | Between unrelated tasks |
| `/permissions` | View / edit permission rules | Pre-allowlist before YOLO sessions |
| `/plugin` | Install / uninstall plugins | Per profile setup |
| `/ultrareview` | Built-in deep review (CC 2.1.108+) | Before PR ship |
| `/team-onboarding` | Bootstrap CLAUDE.md (CC 2.1.111+) | New repo on an existing team |
| `/rewind` | Checkpoint rewind | When a tool call produced garbage |
| `/mcp` | List enabled MCP servers | Monthly audit |
| `/cost` | Current session cost | Token hygiene checks |
| `/resume` | Resume a named session | Multi-day work |
| `/reload-plugins` | Reload plugin dir | After editing a plugin |

---

## Community / adopted

### `/ship` or `/push`
Wraps: stage relevant files + commit with auto-generated message + push + create PR.
Source: adapt from `wshobson/commands/git-ops` (MIT).
Billington Works variant: add the "run security-scanner agent" gate before push for any client repo.

### `/scrape <url>`
One-shot Firecrawl + summarize.
Source: custom under `~/.claude/commands/scrape.md`. Prompt: "Scrape {url} via Firecrawl, extract main text + key tables, save to output/scrape-{timestamp}.md."

### `/gas-deploy`
CLASP push + verify stable deployment + grab URL.
Source: custom, wraps `apps-script-deployer` skill.
Always confirms scriptId unchanged.

### `/estimate`
Freelance scoping template for Billington Works engagements.
Source: custom. Prompt: "Using Brainstorm skill, produce a scoping estimate for the described work: hours range, risks, dependencies, recommended pricing model (fixed / weekly / hourly), recommended subagent plan."

### `/handoff:create`, `/handoff:resume`, `/handoff:quick`
From `willseltzer/claude-handoff` (verify license before adapting).
Paraphrase the command bodies if license is unclear; pattern is simple enough to re-derive.

### `/learn-rule`
From the `rohitg00/pro-workflow` compound-engineering pattern.
Captures a correction, appends to `~/.claude/learnings.md`, auto-loaded via SessionStart hook.

### `/lisp <task>`
Wraps `autocad-mcp` dispatch with Brent's P&ID / civil conventions.
Source: custom, pairs with `civil-eng-qto-helper` skill.

### `/audit-brand`
Runs the `halff-brand-auditor` agent against the current repo or directory.
Produces a report and stops before auto-fixing.

---

## Author-your-own pattern

1. Create `~/.claude/commands/<name>.md` (user-global) or `.claude/commands/<name>.md` (project).
2. Frontmatter: `description:` (short, what + when), `allowed-tools:` (pre-approve).
3. Body: the prompt that Claude should treat as the user message when invoked.
4. Arguments: `$ARGUMENTS`, `$1`, `$2`, `$name` with `arguments:` frontmatter.
5. Test with `/your-command test-arg` before trusting it on real work.

Keep command bodies under ~50 lines. If longer, it wants to be a skill.

---

## Commands to NOT write

- `/deploy-prod` — too dangerous to auto-invocable. Keep deploys manual + gated.
- `/commit` auto-invocable — side-effecting. If you have one, set `disable-model-invocation: true`.
- `/clean` or `/reset` — destructive. Let the user type `rm` themselves.
- Commands that re-invoke Claude with long outputs — that's what subagents are for.

Rules come from ANTI_PATTERNS.md A14 and general safety discipline.
