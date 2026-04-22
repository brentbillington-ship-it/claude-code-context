---
name: campaign-data-processor
description: Use when processing Texas campaign-district voter files or similar political-geography datasets — filtering by precinct/district/party, geocoding addresses, producing heatmap input tables, merging with canvassing-app outputs. Do not use for general data cleaning or non-political datasets.
when_to_use: The user mentions voter file, precinct, district, canvassing, Canvassing Map, Canvassing App, heatmap, walk list, knock list, turf, or political GIS data.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Campaign Data Processor

Skill for the Canvassing-Map project family (see CLAUDE_CODE_STANDING_RULES.md § Active Projects) and related campaign-geography pipelines.

## Inputs

- Voter file CSV/Excel from a state party, VAN export, or county clerk
- A targeting spec (age band, party score, turnout likelihood, geography filter)
- Optional: Canvassing-Map Google Sheet as the output sink

## Procedure

1. **Validate schema first.** Voter files vary per state and per vendor. Print the column list + sample row before anything else. Ask for mapping only if the standard fields (voter_id, first/last name, address, precinct, party, age, score) aren't obvious.
2. **Filter.** Apply the targeting spec as a single pandas expression. Log filter cardinality before/after.
3. **Geocode.** Use whatever geocoder is live in the project (Google Maps, Census, Mapbox) — never guess coordinates. Cache results in `.cache/geocode.sqlite` so re-runs don't re-bill.
4. **Output.** For Canvassing-Map: write directly to the Google Sheet via `google_workspace_mcp`. For heatmaps: emit a grid-bucketed CSV with `lat_bin, lng_bin, count`. For walk lists: PDF via Claude vision-compatible intermediate.
5. **Never write the raw voter file back to a synced cloud location.** Voter-file licenses forbid re-distribution.

## Non-negotiables

- Voter-PII handling: no PII in logs, no PII in commit messages. All credentials via env vars.
- Password for Canvassing-Map dev: `choochoo` (per standing rules; keep in `CLAUDE.local.md`, never committed).
- Timestamps in Central Time for any output handed to field staff.

## Pairs with

- `google_workspace_mcp` for Sheets writes
- `Playwright CLI` for any VAN scraping steps
- `bw-client-deliverable` skill when packaging for a campaign client
