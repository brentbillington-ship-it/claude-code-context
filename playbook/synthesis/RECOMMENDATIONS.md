# Recommendations — Prioritized Action List

Every item has: **What**, **Why**, **Effort** (S/M/L), **Impact** (Low/Med/High), **Risk**, **Sources**, **Dependencies**. Ordered by impact ÷ effort, not by area.

S = under 1 hour. M = 1–4 hours. L = a day or more.

---

## P0 — Quick wins (do first thing in the morning)

### 1. Ship the six hook scripts
- **What:** Add `hooks/` scripts for: formatter (Ruff/Prettier/Black), rm-rf guard (PreToolUse Bash), secret-scan (PreToolUse Write/Edit), SubagentStop queue pump, Stop desktop-notify, SessionStart git-context injector.
- **Why:** Turns advisory CLAUDE.md rules into deterministic enforcement. Eliminates the rm-rf horror-story failure mode. Makes CCC production-grade.
- **Effort:** M (2–3h for all six, most are <30 lines each).
- **Impact:** High.
- **Risk:** Low if each hook is ≤200ms and no PostToolUse hook calls Claude. Follow ANTI_PATTERNS.md #1 strictly.
- **Sources:** `anti-patterns.md` #1/#3, `github.md` (disler), `reddit.md` signal #3.
- **Dependencies:** None — standalone scripts.
- **Files:** `playbook/templates/hooks/*.sh` (drafted). Proposal: `01-hooks-directory.proposal.md`.

### 2. Ship 6 SKILL.md scaffolds
- **What:** `civil-eng-qto-helper/`, `campaign-data-processor/`, `halff-brand-compliance/`, `scraping-pipeline-boilerplate/`, `bw-client-deliverable/`, `apps-script-deployer/`.
- **Why:** Skills are Anthropic's recommended abstraction. All Brent's stacks would benefit. Current CCC `skills/` folder is empty despite README promising skills.
- **Effort:** M (30 min each if the frontmatter is right).
- **Impact:** High.
- **Risk:** Low. Skill bodies can always be iterated.
- **Sources:** `anthropic.md` (skills guide), `practitioners.md` (Thariq skill design).
- **Dependencies:** Read the Anthropic skill frontmatter spec once.
- **Files:** `playbook/templates/skills/<name>/SKILL.md`. Proposal: `02-skills-directory.proposal.md`.

### 3. Ship 6 CLAUDE.md project-type templates
- **What:** `campaign-tool.CLAUDE.md`, `civil-eng-autolisp.CLAUDE.md`, `web-app.CLAUDE.md`, `scraping-pipeline.CLAUDE.md`, `apps-script.CLAUDE.md`, `client-deliverable.CLAUDE.md`.
- **Why:** Every new project gets a working starting kit. Keeps <200 lines per file (community consensus).
- **Effort:** M (2h total).
- **Impact:** High.
- **Risk:** Low.
- **Sources:** `freelancer.md` (3-tier pattern), `github.md` (citypaul, abhishekray07).
- **Dependencies:** None.
- **Files:** `playbook/templates/claude-md/`. Proposal: `03-projects-directory.proposal.md`.

---

## P1 — High leverage, slightly bigger lift

### 4. Install Serena MCP
- **What:** Add `oraios/serena` to the MCP server list, scope it per-project not user-global.
- **Why:** Single biggest productivity jump for multi-file work (symbol-level nav across 30+ languages). Works on Python/Playwright/JS/TS; lifts Brent's scraping refactor speed dramatically.
- **Effort:** S (install + test in one project).
- **Impact:** High.
- **Risk:** Adds ~8k tokens to context; mitigate via project-scoped config.
- **Sources:** `tools.md` #1 Essential.
- **Dependencies:** None.
- **Proposal:** `04-CLAUDE_CODE_STANDING_RULES-serena.proposal.md` (add to MCP table).

### 5. Adopt `claude-code-profiles` for per-client isolation
- **What:** Install `pegasusheavy/claude-code-profiles`. Create profile `bw-<client>` per active Billington Works engagement.
- **Why:** Credential bleed prevention + audit trail for clients. The single biggest compliance-visible improvement for freelance work.
- **Effort:** M (half a day to set up the first 2–3 profiles and script switching).
- **Impact:** High for Billington Works.
- **Risk:** Low. Reversible.
- **Sources:** `freelancer.md` #1.
- **Dependencies:** None.
- **Proposal:** `05-billington-works-delivery-bundle.proposal.md` (covers this + items 6–8).

### 6. Write the Billington Works AI contract addendum
- **What:** One-page addendum: tool whitelist, no-training warranty, human-review clause, IP assignment of human contributions, 72-hour breach notice, audit right.
- **Why:** Legal cover + client trust. Becomes a differentiator vs. "vibe coders."
- **Effort:** M (draft in 2h; lawyer review once = reusable forever).
- **Impact:** High for client-facing work.
- **Risk:** Medium — don't ship without a lawyer reviewing at least once.
- **Sources:** `freelancer.md` (contract clauses section).
- **Dependencies:** Item 5.

### 7. Build the Billington Works template repo
- **What:** Private GitHub repo `bw-project-template` with: pre-wired `CLAUDE.md`, `.claude/settings.json` (deny secrets), devcontainer reference, HANDOFF.md scaffold, AI addendum boilerplate, auto-README skill.
- **Why:** Every new client engagement = `gh repo create --template bw-project-template`. Moat.
- **Effort:** M (mostly wiring together items 1–6 + trailofbits devcontainer).
- **Impact:** High.
- **Risk:** Low.
- **Sources:** `freelancer.md` #8.

### 8. Adopt HANDOFF.md convention
- **What:** `/handoff:create`, `/handoff:resume` slash commands. Every project ends with a HANDOFF.md before close.
- **Why:** Client deliverable + agent-to-agent continuity + your own re-engagement fuel.
- **Effort:** S (adapt `willseltzer/claude-handoff`; paraphrase since license isn't confirmed MIT).
- **Impact:** Medium-High.
- **Risk:** Low.
- **Sources:** `freelancer.md` (HANDOFF.md section).

---

## P2 — Worth doing, can wait

### 9. Ship 10 reusable agent templates
- **What:** `code-reviewer`, `research-subagent`, `deploy-verify` (generic), `data-extractor`, `browser-qa` (generic), `security-scanner`, `doc-writer`, `checkpoint-keeper`, `client-deliverable-packager`, `halff-brand-auditor`.
- **Why:** Matches the wshobson/agents value prop; gives Brent a lexicon. AGENT_MANAGER.md already has the template.
- **Effort:** L (10 agents × 30 min).
- **Impact:** Medium.
- **Risk:** Low.
- **Sources:** `github.md` (wshobson/agents), existing `AGENT_MANAGER.md`.
- **Proposal:** `06-agents-templates.proposal.md`.

### 10. Adopt compound-engineering loop
- **What:** `[LEARN]` capture in Stop hook → appended to `~/.claude/learnings.md` → loaded on SessionStart. Optional: SQLite + FTS per `rohitg00/pro-workflow`.
- **Why:** Mistakes stop recurring. #2 Reddit tip across all threads.
- **Effort:** M (shell script + markdown append is trivial; SQLite path is a weekend).
- **Impact:** Medium (grows over time).
- **Risk:** Low.
- **Sources:** `reddit.md` #2, `github.md` (rohitg00).

### 11. Install trailofbits devcontainer
- **What:** Use `trailofbits/claude-code-devcontainer` as the sandbox for any untrusted client repo or YOLO-mode session.
- **Why:** Auto mode + container = safe parallelism. Specifically mitigates the `rm -rf ~/` failure class.
- **Effort:** M (one-time docker setup).
- **Impact:** Medium (high for specific incidents).
- **Risk:** Low.
- **Sources:** `anti-patterns.md` #6, `freelancer.md` #3.

### 12. Replace auto-compact default with manual `/compact`
- **What:** Disable auto-compact in settings; run `/compact "preserve: <decisions, files, open questions>"` at ~80%.
- **Why:** Community claim: reclaims 33% of context window. Contradicts Anthropic's default — flagged.
- **Effort:** S (one settings flag + one habit change).
- **Impact:** Medium (contested).
- **Risk:** Medium — this contradicts Anthropic's advice. Test on one project first.
- **Sources:** `reddit.md` #5, `hn.md` (restart-over-repair).

### 13. Adopt `/ultrareview` + cross-model review
- **What:** Standardize on `/ultrareview` before `git push`. Optional: layer `hamelsmu/claude-review-loop` pattern with Codex as independent reviewer.
- **Why:** Self-review conflict of interest is a real failure mode (ANTI_PATTERNS #7). Cross-model reviewer is the falsifier.
- **Effort:** S (built-in command) to L (Codex integration).
- **Impact:** Medium.
- **Risk:** Low.
- **Sources:** `anti-patterns.md` #7, `hn.md` (code-review thread).

### 14. Pick 3 wshobson plugins (don't install the whole bundle)
- **What:** `claude-code-essentials`, `security-hardening`, `git-ops` from `wshobson/commands`.
- **Why:** Highest-adoption slash commands. Cherry-pick > all-in.
- **Effort:** S.
- **Impact:** Medium.
- **Risk:** Low (MIT, can uninstall).
- **Sources:** `tools.md` plugin section.

### 15. Add autocad-mcp (if CAD work recurs)
- **What:** Install `puran-water/autocad-mcp`, write `civil-eng-qto-helper` skill wrapper.
- **Why:** Only credible civil/CAD bridge in the ecosystem. Direct Halff fit.
- **Effort:** M (install + test in one drawing).
- **Impact:** Medium-High for Halff work specifically.
- **Risk:** Medium (unknown license, niche maintainer — verify before committing to production).
- **Sources:** `tools.md`, `github.md` (puran-water).

---

## P3 — Nice to have / selective

### 16. Add Exa + Firecrawl MCPs for campaign research
- **What:** Install selectively when scraping/research work is active. Don't leave on.
- **Why:** Replaces ~80% of ad-hoc web scouting. 6k tokens each.
- **Effort:** S.
- **Impact:** Low-Medium.
- **Risk:** Low.
- **Sources:** `tools.md`.

### 17. Simon Willison's transcript-export tooling
- **What:** `simonw/claude-code-transcripts` for publishing session logs as HTML.
- **Why:** Audit artifact + portfolio fuel for Billington Works.
- **Effort:** S.
- **Impact:** Low-Medium.
- **Risk:** Low.
- **Sources:** `practitioners.md`.

### 18. Document CLAUDE.local.md convention
- **What:** One paragraph in CLAUDE_CODE_STANDING_RULES.md explaining what goes in `CLAUDE.local.md` vs. `CLAUDE.md` (sandbox URLs, test creds, etc.).
- **Effort:** S.
- **Impact:** Low.
- **Risk:** Low.
- **Sources:** `freelancer.md` (abhishekray07 3-tier).

### 19. Add an "output style" entry to standing rules
- **What:** One paragraph mentioning Default / Explanatory / Learning output styles; recommend Default for most work.
- **Effort:** S.
- **Impact:** Low.
- **Risk:** Low.
- **Sources:** `anthropic.md` (changelog).

### 20. Consider git worktree pattern for big refactors
- **What:** Document `claude --worktree <name>` + tmux for parallel sessions. Skip for most projects.
- **Effort:** S.
- **Impact:** Low for solo dev, higher if Brent expands to parallel campaign tooling + scraping work.
- **Sources:** `reddit.md` #10, `practitioners.md` (Boris 5 tabs).

---

## Summary table

| Priority | # | Item | Effort | Impact |
|---|---|---|---|---|
| P0 | 1 | Hook scripts | M | High |
| P0 | 2 | SKILL.md scaffolds | M | High |
| P0 | 3 | CLAUDE.md templates | M | High |
| P1 | 4 | Serena MCP | S | High |
| P1 | 5 | claude-code-profiles | M | High (BW) |
| P1 | 6 | AI contract addendum | M | High (BW) |
| P1 | 7 | Template repo | M | High |
| P1 | 8 | HANDOFF.md | S | Med-High |
| P2 | 9 | 10 agent templates | L | Med |
| P2 | 10 | Compound-engineering loop | M | Med |
| P2 | 11 | Devcontainer | M | Med |
| P2 | 12 | Auto-compact off | S | Med |
| P2 | 13 | `/ultrareview` + cross-model | S–L | Med |
| P2 | 14 | 3 wshobson plugins | S | Med |
| P2 | 15 | autocad-mcp | M | Med-High (Halff) |
| P3 | 16–20 | Exa/Firecrawl, transcripts, docs | S | Low-Med |

**Top 3 for MORNING_BRIEF:** Items 1 (hooks), 4 (Serena), 5+6+7 bundled (Billington Works delivery bundle).
