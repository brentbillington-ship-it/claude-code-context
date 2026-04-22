# Marketplace Catalog

CC plugin marketplaces worth subscribing to, with trust notes.

Source basis: `playbook/research/github.md`, `playbook/research/tools.md`, `playbook/research/anti-patterns.md`.

---

## Official

### Anthropic Official Marketplace
- Auto-available; ~101 plugins as of April 2026.
- Submit via `claude.ai/settings/plugins/submit` or `platform.claude.com/plugins/submit`.
- Trust level: highest (Anthropic-vetted).
- Use for: defaults and Anthropic-authored skills (Excel, PowerPoint, PDF, Word).

---

## Trusted community

### `trailofbits/skills-curated`
- **Trust level:** high. Every plugin code-reviewed by Trail of Bits.
- **Use for:** security-sensitive work and client engagements.
- **Caveat:** selection is smaller — curation, not breadth.
- **Repo:** github.com/trailofbits/skills-curated (confirm license before redistribution).

### `obra/superpowers-marketplace`
- **Trust level:** high (Jesse Vincent / Superpowers ecosystem).
- **Use for:** Superpowers-family skills; Private Journal MCP; Elements of Style.
- **Caveat:** overlaps with the Superpowers v5.0.7 Brent has pinned — don't double-install core.

### `ccplugins/awesome-claude-code-plugins`
- **Trust level:** medium-high. Curated list, well-filtered.
- **Use for:** discovery. Not a direct-install marketplace.

### `wshobson/agents` (+ `wshobson/commands`)
- **Trust level:** medium. Large output but active maintainer.
- **Use for:** cherry-picking individual plugins. Don't install the whole bundle.
- **Token warning:** some `wshobson` bundles are heavy; enable one at a time.

---

## Discovery-only (don't subscribe)

### `hesreallyhim/awesome-claude-code`
- Licence: **CC-BY-NC-ND-4.0** — non-commercial, no derivatives.
- Citable only. Do NOT copy files or adapt.
- Use as a weekly discovery browse.

### `ComposioHQ/awesome-claude-plugins`
- Heavy on Composio's own offerings. Skim; don't subscribe.

### `mcp.so`, `mcpservers.org`, `glama.ai`
- MCP server discovery (not CC plugin marketplaces).
- Use when hunting for a specific MCP.

---

## SKIP

### Any "marketplace" that is really just a git repo with a `README.md`
- No `marketplace.json`, no versioning, no managed-settings enforcement.
- Silent breakage on update.
- See ANTI_PATTERNS.md A9.

### Marketplaces pushing >50 plugins at once
- Each plugin is code that runs in your session. Vet the ones you use; don't enable bulk.

### Star-farmed "awesome" lists with zero real `.claude/` content
- High star counts do not correlate with substance (per `github.md` red flags).

---

## Subscription strategy

**Minimum viable subscription list for Billington Works:**
1. Official Anthropic marketplace (baseline).
2. `trailofbits/skills-curated` (for client work).
3. `obra/superpowers-marketplace` (since Superpowers is already in use).

**Optional, per-project:**
4. `ccplugins/awesome-claude-code-plugins` for discovery during planning phases.
5. Cherry-pick from `wshobson/commands`.

Do not subscribe to >5 marketplaces. Each one increases the tool-search surface area.

---

## Vetting a new marketplace (checklist)

Before subscribing:

- [ ] Real `marketplace.json` present and versioned
- [ ] License clear on the marketplace repo (MIT / Apache / BSD preferred; avoid CC-BY-NC-ND)
- [ ] Active commits in last 90 days
- [ ] Plugin code is reviewable (no binary-only distributions)
- [ ] No requirement to POST telemetry to a third-party
- [ ] Maintainer identity is public (not a pseudonymous throwaway)
- [ ] At least one plugin in the marketplace has been used by someone Brent trusts

Log the subscription + rationale in a local note (`~/.claude/notes/marketplaces.md`) so the next audit has a paper trail.
