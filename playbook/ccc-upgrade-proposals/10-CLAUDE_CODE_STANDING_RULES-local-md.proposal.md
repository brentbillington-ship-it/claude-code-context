# Proposal 10 — Document the three-tier CLAUDE.md convention

| Field | Value |
|---|---|
| Target file(s) | `CLAUDE_CODE_STANDING_RULES.md` § CLAUDE.md Rules |
| Change type | MODIFY (expand existing section) |
| Effort | S |
| Impact | Low-Medium |
| Risk | Low |
| Sources | `playbook/research/freelancer.md` (abhishekray07 3-tier pattern) |
| Dependencies | None |

---

## Rationale

Current standing rules mention `CLAUDE.local.md` in one line. Community consensus (abhishekray07, citypaul, ryoppippi) is a three-tier pattern that resolves cross-engagement context bleed. Worth documenting explicitly.

## Change — proposed diff

### Before (lines 215–223)

```markdown
## CLAUDE.md Rules (for project-level files)

- Keep under 200 lines — if removing a line wouldn't cause mistakes, cut it
- Critical rules go in the **first 5 and last 5 lines** — middle content gets less attention
- MUST use positive framing — "MUST use named exports" not "do NOT use default exports"
- Build/run commands belong at the very top
- Code style rules belong in Ruff/ESLint config, not CLAUDE.md
- Use `CLAUDE.local.md` (git-ignored) for personal sandbox URLs and test credentials
```

### After

```markdown
## CLAUDE.md Rules (for project-level files)

### Three-tier convention

| File | Scope | Committed? | Ships to client? |
|---|---|---|---|
| `~/.claude/CLAUDE.md` | Global, yours. Generic defaults across projects. | No (personal) | Never |
| `<repo>/CLAUDE.md` | Project, the client's or the project's. | Yes | Yes |
| `<repo>/CLAUDE.local.md` | Personal sandbox URLs, dev passwords, test creds | No (gitignored) | Never |

`~/.claude/CLAUDE.md` stays short and generic — things true across every project you touch.
`<repo>/CLAUDE.md` ships with the repo; clients read it. No personal context, no branding bleed.
`<repo>/CLAUDE.local.md` is yours, gitignored. Dev passwords (`choochoo`), sandbox URLs, test accounts.

### Content rules

- Keep each file under 200 lines — if removing a line wouldn't cause mistakes, cut it
- Critical rules go in the **first 5 and last 5 lines** — middle content gets less attention
- MUST use positive framing — "MUST use named exports" not "do NOT use default exports"
- Build/run commands belong at the very top
- Code style rules belong in Ruff/ESLint config, not CLAUDE.md
- No shared CLAUDE.md across clients — use `claude-code-profiles` for per-client isolation (see § Billington Works — Client Delivery Protocol)
```

## Footer

- [ ] Approved by Brent
