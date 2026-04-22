# Plugin Catalog — Recommended Claude Code Plugins

Ranked by practitioner adoption + fit for Brent's stack. Install via `/plugin` or from a `marketplace.json`. Pin versions.

Source basis: `playbook/research/tools.md`, `playbook/research/github.md`, `playbook/research/practitioners.md`.

---

## Strong adds

### `wshobson/commands` (pick subset — not the whole bundle)
- **Pick:** `claude-code-essentials`, `security-hardening`, `git-ops`.
- **Why:** Highest-adoption production slash commands. Cherry-pick rather than install the whole 78-plugin fleet.
- **Adopt:** slowly; enable one bundle, use for a week, enable next.
- **Source:** `tools.md` plugin section.
- **License:** MIT (verify on their repo).

### `Local-Review`
- **Purpose:** Parallel multi-agent diff review on local branches before PR.
- **Why:** Independent-review discipline matches RECOMMENDATIONS.md #13. Local (no upload) is a bonus for client work.
- **Pair with:** `code-reviewer` agent template.

### `obra/superpowers-marketplace`
- **Purpose:** Jesse Vincent's curated marketplace; includes Superpowers core (which Brent already has) + Elements of Style + Private Journal MCP.
- **Why:** Already aligned with Brent's Superpowers usage; low friction.
- **Caveat:** Check whether enabling this duplicates the Superpowers v5.0.7 Brent has pinned.

---

## Nice-to-have

### `trailofbits/skills-curated`
- **Purpose:** Security-audited marketplace; every plugin code-reviewed by Trail of Bits.
- **Why:** Anti-supply-chain-attack hedge. Small selection, high trust.
- **Adopt:** as the default marketplace for any client-facing work that touches credentials.

### `Claude-Mem` (thedotmack)
- **Purpose:** Cross-session memory via SQLite + vector.
- **Why:** Supports the compound-engineering pattern (RECOMMENDATIONS.md #10).
- **Caveat:** Some users report context bloat on older versions. Test on one project first.

### `Pensyve`
- **Purpose:** Universal memory runtime with lifecycle hooks.
- **Why:** Overlap with Claude-Mem — pick one, not both.

### `harperreed/project-workflow-system`
- **Purpose:** Task + review + deploy command set.
- **Why:** Overlaps partially with Superpowers Brainstorm. Nice-to-have only.

---

## SKIP

- **`connect-apps` (Composio)** — 500+ SaaS integrations behind one OAuth. Token cost explodes. Only relevant if Brent adds CRM/Stripe/Intercom needs.
- **Any plugin requiring telemetry send to a third party** — incompatible with client-work norms.
- **Plugins with <6 months of commit history** — unless Brent has personally read every file.

---

## Installation discipline

1. Only install plugins from trusted marketplaces — `obra/superpowers-marketplace`, `trailofbits/skills-curated`, `wshobson/*`, official Anthropic, `ccplugins/awesome-claude-code-plugins`.
2. Pin versions. Never install "latest" for a plugin that runs in a client session.
3. Read the hook scripts before enabling. If a plugin includes a PostToolUse hook, confirm it does NOT invoke Claude recursively (ANTI_PATTERNS.md A1).
4. `/reload-plugins` after each config change.
5. Audit `/plugin` list quarterly; uninstall the unused.

---

## Per-profile plugin loadouts (suggested)

Assuming Brent uses `claude-code-profiles` per client (RECOMMENDATIONS.md #5):

| Profile | Plugins |
|---|---|
| `personal` / sandbox | wshobson/claude-code-essentials, Claude-Mem |
| `halff` | wshobson/security-hardening, Local-Review |
| `bw-<client>` (baseline) | trailofbits/skills-curated, wshobson/git-ops, Local-Review |
| `campaign-tooling` | wshobson/claude-code-essentials |
| `scraping` | wshobson/claude-code-essentials, Local-Review |

Tune per engagement. If in doubt, start minimal.
