# Proposal 09 — AGENT_MANAGER.md: add subagent-usage rules

| Field | Value |
|---|---|
| Target file(s) | `AGENT_MANAGER.md` |
| Change type | ADD (new subsection) |
| Effort | S |
| Impact | Medium |
| Risk | Low |
| Sources | `playbook/synthesis/ANTI_PATTERNS.md` A10/A6, `playbook/synthesis/PATTERNS.md` #5/#6 |
| Dependencies | None |

---

## Rationale

`AGENT_MANAGER.md` has excellent lifecycle discipline (registry + retirement triggers). Missing: *usage* rules — when to spawn, how deep, what to summarize back. These are the patterns every surveyed repo gets wrong.

## Change — proposed new subsection

Add after § Lifecycle Rules:

```markdown
---

## Subagent Usage Rules

### When to spawn
- Side-task output would exceed ~5,000 tokens (grep bombs, file surveys, logs)
- You need tool isolation (read-only Explore, Plan-only, etc.)
- Independent review (code review by a different model — never self-review)
- Parallel info-gathering where the results are independent

### When NOT to spawn
- Sequential work that would fit in ~1,500 tokens in main context (cold-start cost > savings)
- Work that requires context the parent already has (you'd just pay to rebuild)
- Anything destructive, side-effecting, or multi-step commit/deploy — keep those in the main session

### Nesting rule
**Flat hierarchy only.** One orchestrator, one subagent layer. Never spawn a subagent that spawns another subagent. Use SubagentStop queue-handoff for sequential phases instead (see `playbook/templates/hooks/subagent-stop-queue-next.sh`).

### Parallel cap
2–3 parallel info-gathering subagents max. More than that and orchestrator summary compression loses too much signal.

### Delegation prompt discipline
Every subagent prompt includes:
1. Mission (one sentence)
2. Scope boundaries (what NOT to do)
3. Expected output format + length
4. Single output file path if it writes to disk
5. Short confirmation expectation on return (≤100 words)

Vague prompts = wasted subagent tokens. A well-scoped subagent writes a report; a poorly-scoped one explores forever.

### Review-model rule
Code-review subagents MUST use a different model from the author agent. Cross-model review is the falsifier that prevents self-approval bias.

### Context pass-through
Subagents do not see parent history. Anything the subagent needs must be in its prompt. If the subagent needs a 5k-token spec, paste it in — don't assume inheritance.
```

## Footer

- [ ] Approved by Brent
