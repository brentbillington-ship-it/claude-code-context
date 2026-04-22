# Proposal 04 — Add Serena MCP to standing rules

| Field | Value |
|---|---|
| Target file(s) | `CLAUDE_CODE_STANDING_RULES.md` § MCP Servers |
| Change type | MODIFY (add table row) |
| Effort | S |
| Impact | **High** (productivity for multi-file refactors) |
| Risk | Low |
| Sources | `playbook/research/tools.md` #1 Essential, `playbook/catalogs/MCP_CATALOG.md` |
| Dependencies | None |

---

## Rationale

Serena (`oraios/serena`) provides symbol-level semantic navigation across 30+ languages via LSPs. Multiple scouts flagged it as the single biggest productivity jump for multi-file work. In-place edits without loading whole files is uniquely valuable on Brent's Python/Playwright refactors and scraping-pipeline cleanups.

Not in CCC standing rules today. Adding as Essential (scoped per-project, not user-global, to keep token footprint tight).

## Change — proposed diff

### MCP Servers table (line ~94)

#### Before

```markdown
| Server | Purpose | Priority |
|--------|---------|----------|
| Superpowers v5.0.7 | Brainstorm, Simplify skills | Essential |
| Sequential Thinking | Structured reasoning before coding | Essential |
| pdf-mcp | Large PDF extraction without context overflow | Essential |
| google_workspace_mcp (taylorwilsdon) | Sheets, Drive, Docs data access | Essential |
| github-mcp-server (official) | Repo management, PRs, CI — replaces Chrome MCP hack | Essential |
| Context7 | Library/API documentation | Essential |
| Chrome MCP | JavaScript tool for browser actions | Fallback only |
```

#### After

```markdown
| Server | Purpose | Priority |
|--------|---------|----------|
| Superpowers v5.0.7 | Brainstorm, Simplify skills | Essential |
| Sequential Thinking | Structured reasoning before coding | Essential |
| pdf-mcp | Large PDF extraction without context overflow | Essential |
| google_workspace_mcp (taylorwilsdon) | Sheets, Drive, Docs data access | Essential |
| github-mcp-server (official) | Repo management, PRs, CI — replaces Chrome MCP hack | Essential |
| Context7 | Library/API documentation | Essential |
| Serena (oraios/serena) | Symbol-level semantic code nav across 30+ languages | Essential — per-project scope only |
| Chrome MCP | JavaScript tool for browser actions | Fallback only |
```

Also update the MCP token-budget warning paragraph (currently "Do not exceed ~20k tokens of active MCP servers"):

### Before (line ~104)

```markdown
**MCP token budget warning:** Do not exceed ~20k tokens of active MCP servers. Enable only what the session needs — adding everything at once degrades performance significantly.
```

### After

```markdown
**MCP token budget warning:** Do not exceed ~20k tokens of active MCP servers per project session; keep total visible tools <15. Enable per-project in `.claude/settings.json`, not user-global. Serena adds ~8k when enabled; keep it OFF for non-code-nav sessions (PDF extraction, Apps Script).
```

## Anti-patterns honored

- A2 — MCP footprint discipline maintained
- Installation guidance scoped per-project to avoid bloat

## Risks + mitigations

- **Install fails on a fresh machine.** Mitigation: document the install command in Brent's personal notes (not in this repo) — the MCP_CATALOG has the recipe.
- **Serena version churn.** Mitigation: pin version when supported.

## Footer

- [ ] Approved by Brent
