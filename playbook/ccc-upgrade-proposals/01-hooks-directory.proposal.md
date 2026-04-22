# Proposal 01 — Populate `hooks/` with 7 reference scripts

| Field | Value |
|---|---|
| Target file(s) | `hooks/` directory (currently empty) + one-line add to `CLAUDE_CODE_STANDING_RULES.md` § Ruff PreToolUse Hook |
| Change type | ADD (populate empty directory) |
| Effort | M (2–3h to copy + integrate) |
| Impact | **High** |
| Risk | Low |
| Sources | `playbook/research/anti-patterns.md` #1/#3, `playbook/research/github.md` (disler), `playbook/synthesis/PATTERNS.md` #3 |
| Dependencies | None |

---

## Rationale

CCC standing rules reference the Ruff PreToolUse hook but the `hooks/` directory is empty. Every high-quality `.claude/` repo (disler/claude-code-hooks-mastery, shanraisshan, ChrisWiles) ships working hook scripts. Hooks are the only *deterministic* enforcement mechanism — CLAUDE.md is advisory (model can disobey; ANTI_PATTERNS.md A1–A16).

The 7 scripts already drafted under `playbook/templates/hooks/`:

1. `ruff-pretooluse.sh` — formalizes the rule already in standing rules
2. `rm-rf-guard.sh` — blocks destructive shell commands (Dec-2025 rm -rf ~/ incident)
3. `secret-scan-preedit.sh` — blocks common secret patterns before Write/Edit lands
4. `subagent-stop-queue-next.sh` — queue-handoff pattern for sequential subagent orchestration
5. `checkpoint-autosave.sh` — writes rolling checkpoints on every turn
6. `desktop-notify-on-blocked.sh` — cross-platform Notification hook
7. `desktop-notify-on-complete.sh` — Stop-hook variant

Plus `settings.example.json` showing correct wiring.

## Change — proposed diff

Move (or `cp -R`) `playbook/templates/hooks/` → `hooks/`.

`CLAUDE_CODE_STANDING_RULES.md` § Ruff PreToolUse Hook — replace the inline JSON snippet with a short paragraph pointing at the hooks directory:

### Before (lines ~174–187)

```markdown
### Ruff PreToolUse Hook
Add to Claude Code settings — catches Python issues before they compound:
[json snippet]
```

### After

```markdown
### Hook Scripts
Reference implementations live in `hooks/`. Wire them via a `~/.claude/settings.json` or per-project `.claude/settings.json` that matches `hooks/settings.example.json`. The included scripts are:

- `ruff-pretooluse.sh` — PreToolUse Python lint on Write/Edit
- `rm-rf-guard.sh` — PreToolUse Bash destructive-command blocker
- `secret-scan-preedit.sh` — PreToolUse secret-pattern blocker
- `subagent-stop-queue-next.sh` — SubagentStop queue pump for sequential orchestration
- `checkpoint-autosave.sh` — Stop-hook rolling checkpoint
- `desktop-notify-on-blocked.sh` — Notification hook (cross-platform)
- `desktop-notify-on-complete.sh` — Stop-hook desktop ping

**Non-negotiable:** no PostToolUse hook may invoke Claude (prevents infinite loops — ANTI_PATTERNS.md A1).
```

## Anti-patterns honored

- A1 — no PostToolUse hook spawns Claude
- A5 — rm-rf guard present regardless of YOLO status
- A11 — all hooks redirect stderr; test with `claude --debug`
- A16 — scripts use POSIX shell with explicit shebangs (Windows hooks would need a `.cmd` companion)

## Risks + mitigations

- **User's existing `~/.claude/settings.json` might conflict.** Mitigation: the example JSON uses `$CCC` placeholder; user edits paths once.
- **Hook-loop risk.** Mitigation: zero PostToolUse hooks in the bundle.
- **Windows compatibility.** Mitigation: `desktop-notify-*.sh` has a Windows branch; other scripts work under Git Bash / WSL. Standalone `.cmd` companions can be added later if needed.

## Footer

- [ ] Approved by Brent
