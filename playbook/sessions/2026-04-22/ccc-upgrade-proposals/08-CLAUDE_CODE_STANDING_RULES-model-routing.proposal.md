# Proposal 08 — Model routing defaults in standing rules

| Field | Value |
|---|---|
| Target file(s) | `CLAUDE_CODE_STANDING_RULES.md` § new subsection |
| Change type | ADD |
| Effort | S |
| Impact | Medium (cost control) |
| Risk | Low |
| Sources | `playbook/research/anti-patterns.md` #4, `playbook/research/reddit.md` signal #6 |
| Dependencies | None |

---

## Rationale

Standing rules don't prescribe model defaults. Community consensus is 80/20 Sonnet/Opus with Haiku for mechanical work. `opusplan` (Opus plans, Sonnet executes) saves 60–80%. Missing this guidance leaves cost control to session-by-session judgment.

## Change — proposed new subsection

Add after § Python Stack (around line 188):

```markdown
---

## Model Routing Defaults

| Task type | Default model | Notes |
|---|---|---|
| Architecture decisions, multi-file refactor, Plan Mode | Opus 4.7 | Only when the reasoning depth justifies 5× cost |
| Daily coding, edits, debugging, single-file work | **Sonnet 4.6 (default)** | 80% of sessions |
| Formatting, renames, lookups, boilerplate | Haiku 4.5 | Batched where possible |
| Research scout subagents | Sonnet 4.6 | Breadth-first; no multi-file reasoning needed |
| Code review subagent | **Different model from author** | Cross-model review breaks self-approval bias (ANTI_PATTERNS A6) |

### `opusplan` pattern
For multi-file changes: Opus plans (in Plan Mode), Sonnet executes the plan. 60–80% cost savings vs. Opus-everywhere.

### Ambiguity tax
Opus 4.7 burns 1.5–3× more tokens than 4.6 on lazily-scoped prompts. If a prompt to Opus takes >5 sentences to express, refactor the prompt before paying the ambiguity tax.
```

## Footer

- [ ] Approved by Brent
