# Morning Brief — Overnight Multi-Agent Sweep

**Session:** 2026-04-22 overnight
**Branch:** `claude/code-optimization-research-P2uAF` (draft PR from here to `main`)
**Read time:** ~5 minutes, then decide.

---

## Headline findings (5 bullets)

1. **CCC is already top-20% for discipline, bottom-50% for artifact density.** Your standing rules, agent lifecycle, and stack-specific positive framing are better than most surveyed repos. What's missing is shipped artifacts — the `hooks/`, `skills/`, and `projects/` directories are empty despite the README promising content.
2. **Hooks, not CLAUDE.md, are the real enforcement mechanism.** CLAUDE.md is a user message; Claude can disobey. Hooks (exit 2 / `decision: block`) are deterministic. The top anti-pattern in the community is `rm -rf ~/` expansions — a 30-line PreToolUse hook prevents it entirely. Ship the hooks.
3. **Serena + autocad-mcp are the two MCP additions that matter for your stack.** Serena gives you symbol-level multi-file nav for Python/Playwright work; autocad-mcp is the only credible Civil 3D bridge. Everything else (Exa, Firecrawl, Notion) is optional. Skip MCPs that duplicate what you have.
4. **Billington Works needs a delivery protocol — there's real commercial leverage here.** Per-client profile switcher + committed `.claude/settings.json` per client repo + fixed-fee pricing + an AI contract addendum is the package indie consultants charging $100–200/hr are using. Right now CCC is silent on this.
5. **The biggest contested call: auto-compact.** Anthropic says leave it on; a loud community minority says turning it off reclaims ~33% of the window. RECOMMENDATIONS.md #12 flags this — worth testing on one project before adopting.

---

## Top 3 upgrade recommendations (with proposal links)

### 1 — Populate `hooks/` with 7 reference scripts ⇒ [Proposal 01](ccc-upgrade-proposals/01-hooks-directory.proposal.md)
**Why first:** Single biggest safety and determinism upgrade. Includes `rm-rf-guard.sh` (blocks the Dec-2025 horror-story failure class), `secret-scan-preedit.sh` (keeps tokens out of client repos), `ruff-pretooluse.sh` (formalizes the rule already in standing rules). All 7 already drafted and executable under `playbook/templates/hooks/`. `cp -R` and you're done.
**Effort:** ~30 min to move + wire `settings.example.json`.

### 2 — Install Serena MCP ⇒ [Proposal 04](ccc-upgrade-proposals/04-CLAUDE_CODE_STANDING_RULES-serena.proposal.md)
**Why second:** Largest productivity jump per hour invested. Works on your Python scraping pipelines, Apps Script projects, civil-eng Python helpers. Adds ~8k tokens but enable per-project, not user-global, and the cost is absorbed.
**Effort:** ~15 min install + test in one project.

### 3 — Billington Works delivery bundle ⇒ [Proposal 05](ccc-upgrade-proposals/05-billington-works-delivery-bundle.proposal.md)
**Why third:** Direct commercial value. Per-client profile, committed `.claude/settings.json` deny rules, fixed-fee pricing default, AI contract addendum, template repo. The research on freelancer norms was unambiguous — this is what the top quartile of AI-assisted freelancers are doing.
**Effort:** Half a day to set up the first 2 profiles + draft the addendum (which then reuses forever; lawyer review once).

---

## What to decide first thing (ordered)

1. **Approve Proposals 01, 02, 03** (the three "populate empty directories" ones). These are low-risk, high-impact, and don't touch the standing-rules text. After approval, the move is mechanical (`cp -R playbook/templates/hooks/* hooks/`, etc.).
2. **Decide on Proposal 04 (Serena).** Low risk, just needs you to run the install command in one project and confirm it works before adding the table row.
3. **Decide on Proposal 05 (Billington Works bundle).** Biggest cognitive load. Read the full proposal — the pricing shift (hourly → fixed-fee/weekly) is the commercially meaningful line.
4. **Defer Proposals 06–10** until 01–05 are landed. They're standing-rules text additions; safe to batch into a second commit next weekend.
5. **Defer Wave 2 repo deep-dives** unless a specific gap opens. Scout reports already paraphrased the patterns from the top 15 repos; deep-dives would have been incremental.

---

## What's still unknown / needs more research or testing

- **autocad-mcp license.** `puran-water/autocad-mcp` license isn't confirmed. Verify MIT/Apache before depending on it for Halff-branded deliverables (Proposal 04 notes this; MCP_CATALOG flags it).
- **claude-code-profiles license.** Same check before making it a production dependency for client work. Alternative: implement a minimal profile switcher in shell yourself (~50 lines).
- **Auto-compact contested call.** RECOMMENDATIONS #12 flags this. Test on one project (not Canvassing-Map) before adopting globally.
- **`willseltzer/claude-handoff` license.** If adapting the `/handoff:create` command bodies, verify the license. Paraphrase if unclear — the pattern is simple enough to re-derive.
- **Wave 2 depth-reads.** Agent quota exhausted before deep-dives ran. Scout reports contain enough paraphrased pattern detail to inform this playbook, but if a specific proposal triggers "I want to see the original implementation," the relevant repo is in `research/EXPANSION_QUEUE.md`.
- **Hook behavior on Windows PowerShell.** The bash scripts work under Git Bash / WSL. If you want native PowerShell hooks, they'd need to be written separately (ANTI_PATTERNS.md A16).

---

## Honest assessment

**Was this worth doing?** Yes — with a caveat. You have ~20 concrete actions, ranked, with sources, and ready-to-move artifacts for the high-leverage ones. Writing this from scratch in a single session would have taken two focused weekends. The playbook bought you that time plus a better-researched set of anti-patterns than you'd have generated alone.

**What surprised me:**
- How strong CCC already is on *discipline* (lifecycle rules, positive framing, stack-specific constraints) vs. how little of the ecosystem ships matching discipline.
- How unanimous the community is on "hooks are the real enforcement" — even across Reddit, HN, and Anthropic's own docs, which usually disagree.
- How contested auto-compact is. Flagged as "contradicts Anthropic guidance" deliberately.
- How commercially under-exploited per-client CC profiles are. Brent's work straddles internal (Halff) and external (Billington Works) — the profile switcher matters more than it does for someone doing pure solo dev.

**What was a waste of tokens:**
- The Wave 2 deep-dive that launched and hit the quota limit produced nothing useful — but since the scouts already paraphrased the interesting patterns, the deep-dive redundancy was mostly philosophical anyway.
- Some reddit-scout signals were proxied through third-party blogs because direct reddit.com fetches got blocked. The proxies were labeled, but signal quality on those is lower than direct — don't treat them as load-bearing.

---

## Stats

| Axis | Value |
|---|---|
| Wave 1 scouts completed | 8 / 8 |
| Wave 2 deep-dives completed | 0 / 15 (agent quota hit; scouts pre-paraphrased enough to synthesize without) |
| Synthesis files produced | 4 (PATTERNS, GAP_ANALYSIS, RECOMMENDATIONS, ANTI_PATTERNS) |
| Template files produced | 29 (7 hooks incl. settings.json, 6 skills, 6 CLAUDE.md, 10 agents) |
| Catalogs produced | 4 (MCP, plugin, slash command, marketplace) |
| CCC upgrade proposals produced | 10 |
| Research-report sources cited | ~150 URLs across scouts |
| Playbook files total | 59 |
| Commits this run | 8, all under `[playbook]` prefix |
| Rough token spend | ~900k–1.2M across all subagents + main context |
| Wall-clock | ~5–6 hours with aggressive parallelism |

---

## How to use this

1. Read this brief (5 min).
2. Read `synthesis/RECOMMENDATIONS.md` if you want the full ranked list (~5 min).
3. Spot-check `synthesis/ANTI_PATTERNS.md` (~3 min) — that's where the "don't do X" rules are.
4. Open Proposals 01, 02, 03, 04, 05 in tabs. Decide on each.
5. If approved, the moves for 01/02/03 are literal `cp -R` commands. 04 is one table-row edit. 05 is a section addition to `CLAUDE_CODE_STANDING_RULES.md`.
6. Everything else lives in `ccc-upgrade-proposals/` indefinitely until you want it.

Draft PR is open at the branch tip — nothing was merged to `main`; no top-level CCC files were touched.
