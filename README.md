# claude-code-context

Global Claude Code standing rules, agents, skills, hooks, and research — Brent's operating system for every Claude Code session across every project.

---

## What This Repo Is

The single source of truth for how Claude Code behaves on this account:

- **`CLAUDE_CODE_STANDING_RULES.md`** — the core. Non-negotiable behaviors, environment matrix, model routing, and the discipline sections (R1-R6 research, D1-D8 debugging, S1-S6 senior review, V1-V5 visual review, L1-L6 shipping lessons). Starts with a Core block + section index.
- **`AGENT_MANAGER.md`** — registry and lifecycle rules for every agent playbook. Enforced by the pre-commit hook.
- **`AGENTS_*.md`** — operational playbooks (Canvassing-Map QA/deploy/trace set, plus `AGENTS_RESEARCH_BOOTSTRAP.md`, the pre-flight gate for research sessions).
- **`agents/`** — engagement-tier agents (senior-product-review quality gate, proposal review bundle, family-office-tracker bundle). Subagent YAML frontmatter + prose playbooks.
- **`playbook/agents/`** — the 14 cross-project core agents (first place to look; see the Agent Library Lookup Order in the standing rules).
- **`skills/`** — house skills in official Agent Skills format (`<name>/SKILL.md`): smallest-honest-change, ccc-doctor, ccc-promote, pdf-extract, scraper.
- **`playbook/templates/hooks/`** — guard-hook scripts + `settings.example.json` wiring (secret scan, rm-rf guard, py-pip guard, session-start context, dogfood gate, notify pair, checkpoint autosave, CT commit stamp).
- **`playbook/research/`** — dated scout reports with `verify-by:` freshness stamps; `EXPANSION_QUEUE.md` carries the re-ranked deep-dive queue and the quarterly refresh procedure.
- **`playbook/catalogs/`, `playbook/synthesis/`, `playbook/sessions/`** — tool catalogs, synthesized patterns/anti-patterns, and session archives.
- **`plugin/` + `tools/build-plugin.sh`** — CCC packaged as an installable Claude Code plugin (payload assembled from canonical sources; see `plugin/README.md`).
- **`tools/ccc-doctor.sh`** — mechanical health check: registry drift, dead links, inert hook, secrets, research freshness. Run it at the start of any session that edits this repo.

---

## One-time setup on a fresh clone

```bash
git config core.hooksPath .githooks   # arms the drift guard + secret scan
bash tools/ccc-doctor.sh              # should report 0 FAIL
```

---

## How to Reference at the Start of a Session

Fetch the standing rules:

```
Fetch and apply my standing rules from:
https://raw.githubusercontent.com/brentbillington-ship-it/claude-code-context/main/CLAUDE_CODE_STANDING_RULES.md
```

Or, preferred where a local checkout exists: install the plugin (`bash tools/build-plugin.sh && claude --plugin-dir ./plugin`) and wire `playbook/templates/hooks/settings.example.json`, which injects the rules pointer automatically via the SessionStart hook.

Reference sections by heading ("standing rules § Sandbox / Network"), never by line number.

---

*Last updated: 2026-07-02 (CT) — harness review session*
