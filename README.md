# claude-code-context

Global Claude Code standing rules, skills, and context — applies across all projects.

---

## What This Repo Is

This is the single source of truth for how Claude Code should behave across every project in this account. It contains:

- **Standing rules** — non-negotiable behaviors, tool preferences, and communication style
- **Shared skill files** — reusable task instructions for Claude Code sessions
- **Project templates** — per-repo CLAUDE.md starters
- **Hook configs** — reusable PreToolUse/PostToolUse hook definitions

---

## How to Reference at the Start of a Session

At the beginning of any Claude Code session, fetch the standing rules file:

```
Fetch and apply my standing rules from:
https://raw.githubusercontent.com/brentbillington-ship-it/claude-code-context/main/CLAUDE_CODE_STANDING_RULES.md
```

Or add a `CLAUDE.md` to your project that imports it by reference.

---

## Folder Structure

```
claude-code-context/
├── CLAUDE_CODE_STANDING_RULES.md   # Global rules — fetch at session start
├── skills/                          # Shared skill .md files
│   ├── canvassing-map-console-seed.md
│   ├── pdf-extract.md
│   └── scraper.md
├── projects/                        # Per-repo CLAUDE.md templates
└── hooks/                           # Reusable hook configs (Ruff, etc.)
```

---

*Last updated: April 2026*
