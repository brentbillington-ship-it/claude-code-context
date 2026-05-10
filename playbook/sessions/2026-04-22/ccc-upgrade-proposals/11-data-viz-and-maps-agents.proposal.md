# Proposal 11 — Add data-viz-reviewer and maps-tooling-reviewer agents

| Field | Value |
|---|---|
| Target file(s) | New `AGENTS_DATA_VIZ_REVIEWER.md` + `AGENTS_MAPS_TOOLING_REVIEWER.md` in CCC root + `AGENT_MANAGER.md` registry update |
| Change type | ADD |
| Effort | M (files drafted; ~30 min to move + register) |
| Impact | **Medium-High** (covers a core Brent workflow that had no agent) |
| Risk | Low |
| Sources | `playbook/research/viz-and-maps-references.md` (canonical reference index) |
| Dependencies | Proposal 06 if landing together; otherwise standalone |

---

## Rationale

Brent does substantial data-visualization and map-tool work — business analytics dashboards, campaign turnout viz, Canvassing Map / Signs Map, Municipal Markets regional analysis, Halff-branded civil exhibits. The original 10-agent roster in Proposal 06 didn't cover viz or maps. This proposal closes that gap with two agents rather than one, because the two literatures and toolchains diverge enough that a combined agent is shallow on both.

**Why two, not one:**
- Data viz literature (Tufte / Wilke / Cairo, ColorBrewer, WCAG contrast) is statistics-and-perception.
- Map tooling literature (projections, tile strategy, PMTiles, geocoding, H3 binning, isochrones) is GIS and web infrastructure.
- The overlap is in color palettes (both use ColorBrewer / Viridis family); each agent references the other for cross-cutting concerns.

## What the agents do (short)

### `data-viz-reviewer`
Reviews charts, dashboards, and business-analytics visualizations. Checks chart-type fit (bar vs line vs scatter vs small multiples per the FT Visual Vocabulary), axis honesty (baseline, dual-axis, labels, units), palette choice (sequential / diverging / qualitative + colorblind safety), WCAG 2.2 contrast, redundant encoding (color + pattern), data-ink ratio, title-states-conclusion discipline, library fit, and export format. Pairs with `code-reviewer` for implementation.

### `maps-tooling-reviewer`
Reviews map apps, regional-analysis viz, geospatial pipelines. Checks tile-provider strategy (NOT osm.org from production; API-key restriction), projection correctness (Web Mercator vs equal-area vs Texas State Plane for civil), performance gates (clustering at >500 markers, vector tiles / WebGL at >10k), heatmap honesty (rates not raw counts, privacy aggregation), choropleth normalization, geospatial-format fit, geocoding discipline (batch + cache + PII awareness), offline patterns, accessibility, and a dedicated map anti-pattern sweep.

## Change — proposed action

### Step 1 — copy
```
cp playbook/templates/agents/data-viz-reviewer.md         AGENTS_DATA_VIZ_REVIEWER.md
cp playbook/templates/agents/maps-tooling-reviewer.md     AGENTS_MAPS_TOOLING_REVIEWER.md
```

### Step 2 — AGENT_MANAGER.md registry additions

```markdown
| `AGENTS_DATA_VIZ_REVIEWER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Chart / dashboard / business-analytics viz review | Retired when CI viz-diff tooling covers it end-to-end |
| `AGENTS_MAPS_TOOLING_REVIEWER.md` | **ACTIVE** | 2026-04-22 | 2026-04-22 | Map apps + regional analysis + geospatial pipeline review | Retired when CI map-regression tooling is live |
```

### Step 3 — changelog

```markdown
| 2026-04-22 | CREATE | AGENTS_DATA_VIZ_REVIEWER.md + AGENTS_MAPS_TOOLING_REVIEWER.md | Viz + maps review gap identified post-playbook; added two dedicated agents. See playbook/ccc-upgrade-proposals/11-data-viz-and-maps-agents.proposal.md |
```

## Cross-agent wiring

- **`data-viz-reviewer`** routes map-shaped findings to `maps-tooling-reviewer`.
- **`maps-tooling-reviewer`** routes chart-overlay findings to `data-viz-reviewer`.
- Both route palette findings for Halff-branded deliverables to `halff-brand-auditor`.
- Both route implementation issues to `code-reviewer`.

## Anti-patterns honored

- A6 — viz review is independent from implementation (`code-reviewer` is the separate-pass reviewer)
- A10 — both are leaf agents, no nested spawning
- A13 — both have concrete retirement triggers

## Risks + mitigations

- **Research backing is thinner than the other 10.** The background scouts for this pair hit stream-idle timeouts three times. Mitigation: the agents are written from domain knowledge plus a curated references index (`research/viz-and-maps-references.md`). Every claim in the agents maps to a named source in the references. Future deepening is easy.
- **Palette guidance overlaps with `halff-brand-compliance` skill.** Mitigation: agents defer to the Halff brand whitelist whenever the deliverable is Halff-branded; they only apply generic palette guidance to non-Halff work.

## Footer

- [ ] Approved by Brent
