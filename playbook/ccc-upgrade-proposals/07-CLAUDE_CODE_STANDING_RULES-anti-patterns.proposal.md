# Proposal 07 — Add anti-patterns reference to standing rules

| Field | Value |
|---|---|
| Target file(s) | `CLAUDE_CODE_STANDING_RULES.md` § new subsection |
| Change type | ADD (short subsection + pointer) |
| Effort | S |
| Impact | Medium |
| Risk | Low |
| Sources | `playbook/synthesis/ANTI_PATTERNS.md` (all 18 entries) |
| Dependencies | None (standalone) |

---

## Rationale

Standing rules encode many positive rules ("MUST use Playwright"). Missing: a small, memorable set of anti-patterns with pointers into the full catalogue. These are the fast-blocker rules that should be visible at session start.

## Change — proposed new subsection

Add after § Communication Style (around line 234):

```markdown
---

## Hard Don'ts (see playbook/synthesis/ANTI_PATTERNS.md for full catalogue)

1. **Never write a PostToolUse hook that invokes Claude** — infinite-loop risk. (A1)
2. **Never enable more than ~15 MCP tools at once** — token drain + tool-selection degradation. (A2)
3. **Never let CLAUDE.md grow past 200 lines** — lost-in-the-middle effect. (A3)
4. **Never default to Opus for everything** — 5× cost; Sonnet is daily driver. (A4)
5. **Never use `--dangerously-skip-permissions` outside a container/VM.** (A5)
6. **Never let the same model review its own code** — self-approval bias. (A6)
7. **Never correction-spiral — `/clear` after 2 failed corrections.** (A7)
8. **Never skip Plan Mode on multi-file changes.** (A8)
9. **Never spawn nested subagents.** (A10)
10. **Never put side-effecting slash commands on auto-invocation.** (A14)
11. **Never share a CLAUDE.md across clients.** (A15)

Full reasoning + sources + fixes in `playbook/synthesis/ANTI_PATTERNS.md`.
```

## Risks + mitigations

- **Adds ~15 lines to CLAUDE_CODE_STANDING_RULES.md.** Mitigation: keeps the file under 300 lines (still reasonable though above the 200-line guidance for project CLAUDE.md; this is the global rulebook, and the community consensus allows ~300 lines for user-global).

## Footer

- [ ] Approved by Brent
