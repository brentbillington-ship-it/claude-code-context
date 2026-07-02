# Harness Review — Session Report

**Date:** 2026-07-02 (CT)
**Session:** CCC harness review + improvement (bootstrap CCP, full-plan "go" from Brent)
**Branches:** `claude/ccc-harness-review-d2goqk` on both `claude-code-context` and `BB-Notes`

---

## What the review found (condensed; full detail in the session transcript)

1. **Registry drift despite the drift guard.** Four AGENT_MANAGER rows pointed at `playbook/agents/proposal-*` files that never existed; the real agents sat unregistered at `agents/proposal-*.md` under different names. Root cause: the pre-commit hook was inert (not executable, `core.hooksPath` unset) and validated staging, not path existence.
2. **Environment rules stated as universals.** "Install chromium, never Edge" vs "msedge only" were rules for two different machines; the sandbox had three contradictory narratives (hard-blocked / widenable / WebSearch-only) across CCC and BB-Notes.
3. **Line-number coupling.** BB-Notes referenced the standing rules by line numbers that had already drifted wrong.
4. **A committed dev password** in 8 files, with `CLAUDE.local.md` (the designated home) not even git-ignored.
5. **Currency gap.** Rules written for the April platform: fixed compact thresholds, no model routing for Sonnet 5 / Opus 4.8 / Fable 5, a mechanically broken hook example, a PAT-in-browser GitHub fallback, prose notification instructions duplicating existing hook templates.
6. **Research 10 weeks stale**; the Wave 2 deep-dive queue never executed.
7. **Dogfooding gap.** Empty `hooks/`/`projects/` dirs, non-parsing loose skills, prose agents invisible to routing, hook templates never wired anywhere.

## What changed this session (one commit per line, CCC unless noted)

- `registry:` 4 phantom rows removed, 4 real proposal agents registered, counts fixed
- `hooks:` pre-commit armed (exec bit) + extended with registry-path validation and a secret scan (local denylist support); tested block/pass paths
- `secrets:` password literal removed from 8 files; `CLAUDE.local.md` git-ignored; **rotation of the app password is on Brent** (history retains the value)
- `refs:`/`rules:` line-number references replaced with heading references (BB-Notes CLAUDE.md, worker/README.md) + a standing rule banning them
- `links:` dead paths fixed (DATAVIZ, MARKETPLACE_CATALOG, COLOR_TRACE, AGENT_MANAGER example), six→seven counts, GAP_ANALYSIS + EXPORT README stamped historical
- `rules:` Environment Matrix (Sandbox / Network) + scoped Browser channel section; R1/R3/D8 pointers fixed; `AGENTS_RESEARCH_BOOTSTRAP.md` created and registered (heals the dead BB-Notes inbound reference)
- `rules:` BB-Notes lessons promoted: Shipping Lessons L1-L6 + D6 green-on-main amendment; UPDATE_TO_CCC.md stamped promoted (BB-Notes branch)
- `rules:` currency pass: Context Management rewrite, new Model Routing section (Opus orchestrator + sonnet workers house pattern, Fable heavy-only, ultracode budget rule), Ruff example fixed, notifications point at hook templates, Chrome MCP PAT fallback retired, S6 namespace fixed, Platform Notes section
- `hooks:` four new templates (py-pip-guard, session-start-context, dogfood-suite-gate, git-prepare-commit-msg) + permissions ask/deny action-gate block in settings.example.json; all smoke-tested
- `agents:` subagent YAML frontmatter on senior-product-review (opus) + proposal bundle (sonnet). V1-V5 dedupe resolved as no-change: agent-side blocks are already tuned bindings, not copies
- `skills:` pdf-extract + scraper converted to official `<name>/SKILL.md` format; new smallest-honest-change constraint skill
- `tools:` ccc-doctor.sh (8 check classes; found and fixed a real dead link and its own counter bug on first runs) + ccc-doctor and ccc-promote skills
- `research:` July delta sections in all scout files with cited sources; verify-by stamps; EXPANSION_QUEUE re-ranked with a quarterly refresh procedure
- `plugin:` CCC as installable plugin v0.1.0, payload assembled by tools/build-plugin.sh (no committed copies)
- `rules:` Core block + section index top-loaded (progressive disclosure without breaking the raw URL or any heading reference)
- `readme:` rewritten for the current tree + fresh-clone arming steps

## Wave 2 deep-dive findings (5 repos, 2026-07-02)

- **ponytail (MIT):** the value is a 7-rung decision ladder (need it at all → reuse → stdlib → platform → installed dep → one-liner → minimum code) with two guardrails: understand-first sequencing and a non-negotiables carve-out (validation, error handling, security). CCC's `smallest-honest-change` skill covers the same ground in house voice; consider grafting the explicit ladder.
- **diet103 showcase (MIT) — highest-leverage adoption candidate:** `skill-rules.json` + a UserPromptSubmit router that auto-fires skills from prompt keywords/intent regexes/file patterns, with `guardrail` type + `enforcement: block` + skip conditions. This would convert R1 ("Playwright for visual claims") and the py/python rule from prose into harness-enforced gates. Also: the dev-docs trio (plan/context/tasks files per task) for multi-session builds, and the 500-line skill cap with `resources/` splits.
- **disler/hooks-mastery (NO LICENSE — patterns only, write code fresh):** SessionStart context injection (CCC's session-start-context.sh already implements this), exit-2/stderr idiom, fail-silent discipline, append-only JSON hook logs.
- **wshobson/agents (MIT):** frontmatter minimalism + "Use PROACTIVELY for X" description idiom (adopted in the new frontmatter); tiered `model:` per agent. No scraping/geo/Apps-Script coverage; keep writing bespoke agents there.
- **anthropics/skills (Apache 2.0, document skills source-available):** description formula = what it does + "Use when..."; timed reference loading ("Load X during phase Y"); scripts-in-skill-folder. Adopted in the converted skills.

## Follow-ups (not done this session, in priority order)

1. **Rotate the Canvassing/Signs-Map dev password** — the old value is permanently in git history. (Brent, 5 minutes.)
2. **Local plugin test on the ThinkPad:** `bash tools/build-plugin.sh && claude --plugin-dir ./plugin`, then wire the permissions block from settings.example.json into `~/.claude/settings.json`. Bump plugin to 0.2 when proven.
3. **Build the skill-router** (diet103 pattern): UserPromptSubmit hook + skill-rules.json encoding R1, py/python, and the action gate as guardrail entries. One session, high leverage.
4. **Plan item 19 (migrate AGENTS_* into Canvassing-Map) is BLOCKED in this session** — GitHub scope covered only BB-Notes and claude-code-context. Everything is prepped: the registry note, lookup-order tier 3, and the cross-references in deploy-verify/browser-qa/leaflet-map-debugger are the files to touch when a Canvassing-Map-scoped session runs it.
5. **Splitting standing rules into `.claude/rules/` files** deferred until the plugin has a local test cycle; the Core block + index covers the skim problem meanwhile.
6. Consider the **dev-docs trio** command for the next multi-session BB-Notes build.

## Verification state at session end

`tools/ccc-doctor.sh`: 0 FAIL, 1 WARN (line-number mention inside an archived April proposal, accepted). Pre-commit guard verified blocking on: missing registry update, dead registry path, staged credential pattern. All new hooks smoke-tested including block paths. Plugin build validates hooks.json wiring. Research files all carry verify-by 2026-10-01.
