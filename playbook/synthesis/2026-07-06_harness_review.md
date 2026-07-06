# Harness Review — 2026-07-06 (CT)

MMR-focused improvement pass. Baseline: `2026-07-02_harness_review.md`.
Signal sources: Municipal-Market-Research-Pipeline (`STATE_OF_THINGS.md`,
`LESSONS_LEARNED.md`, `docs/SCRAPER_STRATEGY_GUIDE.md`, `BACKEND_TOGGLE.md`),
Municipal-Market-Dashboard issues #8/#52/#53, local memory dirs, gh keyring,
and a claude.ai chat's hypothesis list (validated against local evidence
before acting).

## What the review found

1. **The scraper skill knew no platforms.** Two years of per-portal
   gotchas (Legistar API, CivicClerk React trap, NovusAgenda
   networkidle trap, PrimeGov DOM drift, Municode pagination) lived only
   in the MMR repo; `skills/scraper/SKILL.md` had one generic Steps list —
   and its networkidle MUST actively contradicted the Houston lesson.
2. **Stale repo map.** § Active Projects still pointed Municipal Markets
   at `brentbillington-ship-it/Municipal-Markets`, a slug that no longer
   exists (moved to `Halff-Citizen-Devs` June 2026). The stale slug
   corrupted this review's own brief and confounded a claude.ai PAT-401
   diagnosis the same day.
3. **Three standing-rules repos, no declared canonical.** This repo, the
   diverged `bbillington/CC-Content` (Halff side, own "Working Discipline"
   section, unpushed commit), and a scrubbed `halff-ccc` export handed
   over 2026-07-06.
4. **Halff SAML SSO credential lapses are a recurring class** (three
   dated MMR recurrences) with a known runbook that lived only in MMR
   session notes.
5. **Uncaptured novel patterns:** ApiBackend/CodeBackend billing routing
   with key-stripping; the executed issue-#52 cost-benchmark method;
   propose-only/refuse-ambiguity invariants for the self-heal agent.
6. **MMR has no `UPDATE_TO_CCC.md`** — promotion required archaeology
   across LESSONS_LEARNED/STATE_OF_THINGS. BB-Notes has the marker file;
   MMR should too.
7. Hypotheses from the claude.ai read that did NOT survive local
   validation: "no exclamation points" comms rule (no evidence);
   Code42/Incydr two-account DLP governance (no evidence — replaced by
   the real finding, #2/#3 above).

## What changed this session

- **Shipping Lessons L7–L11** (grouped-data conclusions, data-gap vs
  market, dedup-path reconciliation, model-divergence exceptions,
  propose-only agents) + networkidle exception amendment in § Playwright,
  `skills/scraper`, and the scraping boilerplate.
- **Scraper skill:** municipal agenda-platform fingerprint table +
  walk-all-pages completeness step (Grand Prairie `&p=1` bug). Source of
  truth remains MMR `docs/SCRAPER_STRATEGY_GUIDE.md`.
- **`skills/civil-doc-review`** (new): sheet-index-first, multi-consultant
  conflict matrix, spec/product cross-check (Celina sessions).
- **§ GitHub:** two-account map, SSO-lapse runbook, wrong-slug check,
  automation-credential least-privilege. **§ Active Projects** corrected.
- **§ Communication Style:** outbound-writing rules (em dashes, double
  spacing, fenced-block delivery).
- **`playbook/BILLING_BACKEND_PATTERN.md`** and
  **`playbook/COST_BENCHMARK_RECIPE.md`**.
- **Skill-router shipped** (07-02 follow-up #3): UserPromptSubmit hook +
  `skill-rules.json`, inject-only v1, tested including the cp1252
  UnicodeEncodeError trap; wired into settings example + plugin; plugin
  0.1.1.

## Follow-ups (not done this session, in priority order)

1. **Decide the CC-Content / halff-ccc question** — phase 2 of this
   session produces the comparison and recommendation; Brent decides
   merge direction. Until then: no rule edits on the Halff side.
2. **Rotate the Canvassing/Signs-Map dev password** — still open from
   07-02 (Brent, 5 minutes). Re-auth the Halff PAT at Configure SSO.
3. **Merge or close draft PRs #4 (AV1–AV5) and #5 (D9–D11)** — written,
   reviewed by no one, aging since 06-26/07-02 (Brent).
4. **Add `UPDATE_TO_CCC.md` to the MMR pipeline repo** so the next
   ccc-promote pass is a file read, not a dig (needs an MMR-repo session;
   governed org repo — PR per GitFlow).
5. **Install the built plugin on this machine and the ThinkPad** and wire
   the permissions block; bump plugin to 0.2 when proven (carried from
   07-02 follow-up #2).
6. **Skill-router v2** — consider PreToolUse blocking enforcement for
   guardrail-class rules once v1's match quality is proven in daily use.

## Verification state at session end

ccc-doctor: 0 FAIL, 1 pre-existing WARN (line-number reference inside an
April proposal archive). Skill-router tested against match, skip,
no-match, and malformed-input cases on this machine's git-bash + py
launcher stack. `tools/build-plugin.sh` assembles 6 skills / 15 agents /
11 hook scripts + rules file. No agent files touched (registry unchanged
by design — civil-doc-review shipped as a skill, not an agent).
