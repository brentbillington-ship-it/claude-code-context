# Playbook — Import Guide for Another Claude Code Account

This bundle is the output of an overnight multi-agent Claude Code workflow-research sweep. Everything lives under `playbook/` so it's a drop-in addition to any repo or a standalone reference bundle.

**Original repo:** `brentbillington-ship-it/claude-code-context`
**Branch:** `claude/code-optimization-research-P2uAF`
**Built:** 2026-04-22

---

## TL;DR — what to do on the new machine

1. Unzip anywhere. If you want it inside another claude-code-context-style repo, drop the whole `playbook/` tree at the repo root.
2. Read `playbook/MORNING_BRIEF.md` first (5 min).
3. Decide which proposals in `playbook/ccc-upgrade-proposals/` to approve.
4. For anything approved, follow the "Where files go" table below.

---

## Where files go in another Claude Code setup

None of this auto-installs — Claude Code doesn't watch a `playbook/` directory. You copy files into the locations Claude Code actually reads from. All paths below are relative to either your `~/.claude/` (user-global) or a project's `<repo>/.claude/` (project-scoped).

| Playbook file(s) | Copy to | Scope |
|---|---|---|
| `playbook/templates/hooks/*.sh` | `~/.claude/hooks/` **or** `<repo>/.claude/hooks/` + `chmod +x *.sh` | User-global for rm-rf guard + secret scan; project for ruff |
| `playbook/templates/hooks/settings.example.json` | Merge into `~/.claude/settings.json` **or** `<repo>/.claude/settings.json` — replace `$CCC` with the absolute path where you put the hooks | Either |
| `playbook/templates/skills/<name>/SKILL.md` | `~/.claude/skills/<name>/SKILL.md` **or** `<repo>/.claude/skills/<name>/SKILL.md` | Project-scoped for stack-specific skills; user-global only for truly generic ones |
| `playbook/templates/claude-md/<type>.CLAUDE.md` | Rename to `<repo>/CLAUDE.md` when starting a new project of that type | Project |
| `playbook/templates/agents/<name>.md` | `~/.claude/agents/<name>.md` **or** `<repo>/.claude/agents/<name>.md` | User-global for generic ones (code-reviewer, research-subagent, doc-writer, etc.); project for stack-specific ones |
| `playbook/catalogs/*.md` | Keep as reference docs in the bundle. They aren't read by Claude Code; they're for you. | Reference |
| `playbook/synthesis/*.md` | Same — reference docs for humans. | Reference |
| `playbook/research/*.md` | Same — source evidence, cited from proposals. | Reference |
| `playbook/ccc-upgrade-proposals/*.md` | Don't copy anywhere automatically. These are proposals against a specific repo (CCC). Use them as a reading list when deciding upgrades. | Reference |

---

## Directory map of the bundle

```
playbook/
├── 00-PLAN.md                                  Plan written at session start
├── CHECKPOINT.md                               Phase-by-phase progress log
├── MORNING_BRIEF.md                            Start here — 5-minute read
├── README_FOR_IMPORT.md                        This file
├── research/                                   Wave 1 scout reports (8)
│   ├── reddit.md
│   ├── github.md
│   ├── anthropic.md
│   ├── hn.md
│   ├── practitioners.md
│   ├── freelancer.md
│   ├── anti-patterns.md
│   ├── tools.md
│   └── EXPANSION_QUEUE.md
├── synthesis/                                  Cross-source synthesis (4)
│   ├── PATTERNS.md
│   ├── GAP_ANALYSIS.md
│   ├── RECOMMENDATIONS.md
│   └── ANTI_PATTERNS.md
├── templates/
│   ├── hooks/                                  7 bash scripts + example settings
│   ├── skills/                                 6 SKILL.md scaffolds
│   ├── claude-md/                              6 CLAUDE.md project templates
│   └── agents/                                 10 reusable agent templates
├── catalogs/                                   Reference catalogs (4)
│   ├── MCP_CATALOG.md
│   ├── PLUGIN_CATALOG.md
│   ├── SLASH_COMMAND_CATALOG.md
│   └── MARKETPLACE_CATALOG.md
└── ccc-upgrade-proposals/                      10 proposals, ordered by impact
    ├── 01-hooks-directory.proposal.md
    ├── 02-skills-directory.proposal.md
    ├── 03-projects-directory.proposal.md
    ├── 04-CLAUDE_CODE_STANDING_RULES-serena.proposal.md
    ├── 05-billington-works-delivery-bundle.proposal.md
    ├── 06-agents-templates.proposal.md
    ├── 07-CLAUDE_CODE_STANDING_RULES-anti-patterns.proposal.md
    ├── 08-CLAUDE_CODE_STANDING_RULES-model-routing.proposal.md
    ├── 09-AGENT_MANAGER-subagent-rules.proposal.md
    └── 10-CLAUDE_CODE_STANDING_RULES-local-md.proposal.md
```

---

## Assumptions made in the bundle

These assumptions are specific to the original account; swap them out for your own setup.

- **Billington Works / Halff Associates context.** Skill scaffolds for `halff-brand-compliance`, `bw-client-deliverable`, `campaign-data-processor`, `civil-eng-qto-helper` are tailored to a civil PE + freelance AI dev stack. Delete or ignore what doesn't apply.
- **Standing rules shape.** Proposals assume the existing CCC has `CLAUDE_CODE_STANDING_RULES.md`, `AGENT_MANAGER.md`, and directories named `hooks/`, `skills/`, `projects/`. If your target repo uses a different layout, the "copy to" paths in proposals need remapping.
- **Stack defaults.** Python with Ruff + Playwright CLI + openpyxl + pandas; Apps Script via CLASP; google_workspace_mcp + pdf-mcp + Context7 + Sequential Thinking MCP + Superpowers. Model routing assumes Sonnet 4.6 daily / Opus 4.7 architecture / Haiku 4.5 mechanical.
- **Hooks use POSIX bash.** Work under Git Bash / WSL / macOS / Linux. Native Windows PowerShell hooks would need rewrites — ANTI_PATTERNS.md A16 flags this.
- **License discipline.** Paraphrased everything from external sources. Two files to verify-before-depending-on: `puran-water/autocad-mcp` license and `willseltzer/claude-handoff` license (flagged in proposals 04 and the slash-command catalog).

---

## Known gaps (from MORNING_BRIEF honest assessment)

- **Wave 2 repo deep-dives were skipped** when agent quota hit. Scout reports pre-paraphrased patterns from the top 15 repos; synthesis proceeded without. `research/EXPANSION_QUEUE.md` has the queued targets if you want to run Wave 2 later.
- **No data-visualization agent.** `research-subagent` covers research breadth, `code-reviewer` covers implementation review, `browser-qa-generic` covers visual output — but there's no dedicated viz-review agent. Reasonable addition if your new account does a lot of charts or maps.
- **Auto-compact stance contested.** Community says disable; Anthropic says leave on. Flagged in RECOMMENDATIONS.md #12. Test on one project before adopting globally.

---

## Recommended reading order for a new reader

1. `MORNING_BRIEF.md` — 5 minutes
2. `synthesis/RECOMMENDATIONS.md` — 5 minutes, full ranked list
3. `synthesis/ANTI_PATTERNS.md` — 3 minutes, hard don'ts
4. `synthesis/PATTERNS.md` — 5 minutes, recurring architectures
5. `catalogs/MCP_CATALOG.md` + `catalogs/SLASH_COMMAND_CATALOG.md` — decide tool changes
6. Browse `ccc-upgrade-proposals/` only when you want the concrete diffs
7. Browse `research/` only when a claim in the synthesis needs a source check

---

## License / attribution

All playbook content paraphrases external sources with URL attribution in the scout reports. No large external code blocks were copied. You can re-use, adapt, and redistribute the playbook contents freely within your own Claude Code setup. If you publish a derivative work publicly, a credit line pointing back to the original `brentbillington-ship-it/claude-code-context` repo is courteous but not required.

---

## Questions you may have

**Will running the hooks break anything?**
Only if you wire PostToolUse hooks that invoke Claude — the bundle deliberately does not. Every included hook is non-recursive and tested against ANTI_PATTERNS.md A1.

**Will `settings.example.json` overwrite my existing settings?**
No — you merge it into your existing `settings.json` manually. It's an example, not a drop-in file.

**Can I use just the skills and ignore everything else?**
Yes. Each subdirectory is independent. Copy only what's useful.

**How do I know a proposal is "approved"?**
Every proposal file has `- [ ] Approved by Brent` at the bottom. In your account, make that checkbox your own — nothing auto-applies.
