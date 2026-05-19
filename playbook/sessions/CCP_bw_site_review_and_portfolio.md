# CCP: Billington Works Site Review + Portfolio Showcase Design

> **Two outputs in one CCP. (1) Multi-agent QA pass on `billingtonworks.com` at v1.4.1 — functional, efficient, looks good. (2) A *designed but not live* portfolio architecture for Brent's existing showcase-eligible work: Chaka campaign tools, Gala Holdings tracker, and possibly the Julie Waters FB scraper.**

> Created 2026-05-19 after the v1.4.0 / v1.4.1 ships that scrubbed MMR framing and tightened service / client copy. The site is now positioned correctly; the next gates are (a) does it actually pass professional review, and (b) what does the portfolio section look like when it lands.

---

## Repos in scope

- `brentbillington-ship-it/billington-works-site` — review target + eventual portfolio host
- `brentbillington-ship-it/bb-notes` — captures the portfolio design doc + any decisions
- `brentbillington-ship-it/claude-code-context` — agent definitions invoked during Phase 1
- Source repos referenced (read-only during this CCP):
  - The Chaka campaign tool repos (Canvassing Map, Sign Map / Routing, Place 5 Tracker, Early Voting Tracker, video captioning pipeline, and whatever "Finance Report" maps to — confirm with Brent in orient)
  - `brentbillington-ship-it/gala-holdings-tracker`
  - `brentbillington-ship-it/bw-fb-participant-export` (Julie Waters)

## Branch for the run

All commits on the executing branch (e.g. `claude/site-review-v142`). No direct pushes to `main`.

---

## Orient first (mandatory before any work)

Read in this order:

1. `claude-code-context/CLAUDE_CODE_STANDING_RULES.md` — surgical edits, Central Time, action gate, no destructive ops.
2. `claude-code-context/AGENT_MANAGER.md` — the registry. Confirm the agents named in Phase 1 are still ACTIVE and read their playbooks before dispatch.
3. `bb-notes/CONTEXT.md` — Brent profile, Halff posture, BW brand + conflict firewall.
4. `bb-notes/notebooks/bw/billington-works.md` — current BW state, positioning notes, "Testimonials & Case Study Assets" section, capture checklist (BLOCKER list before any campaign site takedown).
5. `bb-notes/notebooks/clients/kevin-chaka.md` — IP letter status, testimonial + code-retention ask status, what's actually OK to publish.
6. `bb-notes/notebooks/clients/julie-waters.md` — testimonial state, public/private posture.
7. `bb-notes/CCPs/2026-05-19-scrub-mmr-from-bw-site.md` — the scrub CCP this builds on; constraints carry forward.
8. The current `billington-works-site` repo — `index.html`, `version.js`, `VERSION`, `signature.html`.

If `notebooks/clients/gala-holdings.md` does not exist, pull context from `gala-holdings-tracker/STATE_OF_THINGS.md` and check with Brent before using anything in a public-facing artifact.

Do not edit yet.

---

## Why this matters (don't skip)

- The site is now the production version of how Brent gets discovered. v1.4.1 fixed the framing — but framing is necessary, not sufficient. If the site has slow loads, broken mobile states, contrast failures, console errors, or stale meta tags, it undercuts the credibility the engineer-PE framing is meant to build.
- Portfolio is the next obvious "tell me more" beat after the service cards. Right now there isn't one. Anyone curious has to email — and a serious buyer won't email an empty portfolio.
- Brent has real showcase-eligible work right now (Chaka tools delivered, Gala in active engagement, Julie scraper shipped). The window to capture campaign assets is closing as those sites come down (see BB-Notes capture-checklist blocker).
- This CCP **does not ship the portfolio live.** It designs it, captures the assets safely, and prepares the artifacts so the live launch is a one-decision call later — not a multi-week scramble.

---

## Phase 1 — Site review (multi-agent)

**Objective:** End the v1.x line with a clean, documented baseline. Findings → punch list → either ship v1.4.2 or land in the BB-Notes backlog with rationale.

**Note on `/ultrareview`:** This is the canonical deep multi-agent review and produces the best aggregate output. **It is user-invoked, not agent-invoked** — Brent must run `/ultrareview` himself in the executing session. If he chooses to skip `/ultrareview`, run the four-agent fallback below.

### Four-agent fallback (Claude-dispatchable)

Dispatch in parallel (one tool turn, four `Agent` calls). Each agent produces a Markdown findings doc under `bw-site-review-v141/` in the executing branch. Do **not** apply fixes during this phase — collect findings first, synthesize, then propose.

| # | Agent | Input | Output |
|---|---|---|---|
| 1 | `playbook/agents/browser-qa.md` | Live URL `https://billingtonworks.com` AND local `index.html` open from disk | Screenshots at 360/768/1024/1440px, console-error sweep, network waterfall summary, asset-weight tally, baseline diff vs. previous version if available |
| 2 | `playbook/agents/uix-flow-auditor.md` | Local `index.html` | Per-section UIX checklist: nav (anchor scroll behavior), hero (portrait load failure state, mailto fallback), about callout (long-line / hyphenation), work-grid (7th card border, hover state, mobile collapse), clients (2x2 → 1-col), contact (mailto, dark section a11y), footer | 
| 3 | `playbook/agents/senior-product-review.md` | The full repo + Brent's positioning brief (CONTEXT.md + `bw/billington-works.md`) | S1-S6 senior pass: are claims defensible, does copy fit positioning, what would a senior product lead push back on, what's the next-version gap |
| 4 | `playbook/agents/halff-brand-auditor.md` | Full site | Halff↔BW bleed check: any lingering AEC vocab, Halff color/typography accidents, MMR residue. (Sanity-check the scrub from a fresh pair of eyes.) |

**Synthesis step (no agent):** Read all four reports back-to-back. Produce one consolidated **punch list** ranked Critical / Should-fix / Nice-to-have. Present to Brent as a numbered list. Wait for go.

### Specific things to verify (do not skip even if no agent flags them)

- `VERSION`, `version.js` `SITE_VERSION`, and the HTML build comment all agree.
- `?v=` cache-buster query strings on `version.js` and any other static reference (none currently — confirm).
- OG / Twitter card render correctly (use a card debugger or Playwright fetch + render).
- `portrait.jpg` size — currently ~the largest asset on the page; verify it's appropriately compressed and `<img>` carries `width`/`height` + `loading="lazy"` if below the fold (it's not — hero, so eager is correct).
- `bw_logo.png` is being served at 775x240 displayed at 80px tall — confirm a smaller asset isn't warranted.
- `signature.html` and `signature-preview.html` — confirm they're either still useful or candidates for removal in v1.5.
- `billington_works_market_intel.html` — still noindex; confirm the gating still works post-v1.4.x.

### Phase 1 deliverables

1. Four agent reports (committed to executing branch under `bw-site-review-v141/`).
2. Consolidated punch list (Markdown).
3. Either a v1.4.2 patch PR addressing Critical items, or a backlog entry in `bb-notes/notebooks/bw/billington-works.md` documenting accepted-as-is items with reasoning.

---

## Phase 2 — Portfolio showcase design (design only, no live launch)

**Objective:** Produce a portfolio architecture spec — written, not built — that Brent can approve, then ship in a separate later CCP. This CCP captures the safe assets and decides the shape; it does **not** add HTML to the live site.

### Step 2a — Candidate inventory

Confirm with Brent what each showcase-eligible asset actually is. Brent named:

- **Canvassing Map** (Chaka)
- **Sign Map** (Chaka)
- **Place 5 Tracker** (Chaka) — Brent's "Finance Report" reference resolves to the Place 5 Tracker (confirmed 2026-05-19).
- **Family-office investment tracker** (the engagement formerly drafted in `gala-holdings-tracker`) — **the client is never named anywhere.** No "Gala", no "Gala Holdings", no "Gala Ventures" in any portfolio artifact, draft or published. Always abstracted: "a Texas single-family office," "a private family office," or similar.
- **Maybe the Facebook thing** — Julie Waters FB participant export scraper. Decision deferred to Brent.

### Step 2b — Per-case-study safety gate (mandatory)

For each candidate, answer all six before it can be in the portfolio design:

1. **Consent status.** Written? Verbal? Pending?
2. **Client naming.** Public-named, partially-named, or fully abstracted ("a North Texas school board campaign," "a single-family office," "a viral civic FB group")?
3. **Code retention.** Does Brent have written OK to retain code for portfolio reference?
4. **Asset capture state.** Per the BB-Notes "Per-tool checklist" — screen recording, multi-state screenshots, data export, aggregate metrics, repo tagged, IP letter filed. Capture before sites come down.
5. **Halff conflict check.** Does anything in this case study read as MMR, Halff IP, or Halff-adjacent? (MMR explicitly excluded already.)
6. **Reveal phase.** Does it go in v1 of the portfolio, or stage 2 once consent firms up?

Default-deny on any case study where any of #1–#5 are unresolved.

### Known starting positions (subject to verification during orient)

| Candidate | Consent | Naming | Code retention | Capture state | Phase |
|---|---|---|---|---|---|
| Chaka tools (whole suite, incl. Place 5 Tracker) | IP letter signed; testimonial + code-retention ask sent 5/14, **awaiting reply** | Public OK assumed once Chaka confirms in writing | Pending Chaka's explicit yes | **Blocker: capture checklist incomplete.** Sites still live, can capture now. | v1 of portfolio iff Chaka replies yes; otherwise v2 |
| Family-office tracker (client unnamed) | None for public attribution. NDA in place. | **Hard rule: client is never named.** No "Gala" anywhere — draft, public, internal artifact, screenshot caption, or commit message. Abstracted descriptors only. | N/A (active engagement, no public client name) | Tracker still in scope-confirm; no shippable screenshots yet | v2 — wait until v1 of the tracker is delivered + abstracted screenshots possible |
| Julie Waters FB scraper | Testimonial draft held; ask pending (5-10 day window from 5/14) | **Fully abstracted** unless she explicitly OKs naming | She gave it free; retention is Brent's by default | Live + processing; can capture now | v1 iff testimonial lands + she OKs public attribution; otherwise abstracted v1 |

### Step 2c — Architecture options to evaluate

Produce a **decision memo** (markdown, lives in `bb-notes/notebooks/bw/portfolio-architecture-2026-05.md`) comparing:

- **Option A — `/work` index page + per-case-study sub-pages.** Heavier build; richest. Each case study gets a dedicated page with hero image, problem statement, approach, results, testimonial pull-quote.
- **Option B — Expandable cards on the existing home page.** Lighter; each card on the existing work-grid expands inline to a deeper view. Lower information density but no navigation cost.
- **Option C — Single long-scroll `/work` page, no sub-pages.** Middle ground; easier to maintain, harder to deep-link.
- **Option D — Gated portfolio (login or "request access" link).** Brent shares with prospects on demand; nothing public. Avoids consent ambiguity entirely.

Recommend one. The decision criteria:

- Buyer-friction: how many clicks before they see proof?
- Maintenance: every new case study costs ~X hours
- Consent flexibility: easier to abstract on some layouts than others
- Mobile behavior

### Step 2d — Content template

Define a single Markdown template for case studies so the eventual implementation is mechanical. Fields:

```
Title          (always; phrasing depends on naming policy)
One-line       (≤14 words; what was built, for whom, what changed)
Problem        (2-3 sentences; client-side, no jargon)
Approach       (3-5 sentences; what tech, why, what tradeoffs)
Result         (numbers if possible, testimonial quote if available)
Visuals        (1-3 screenshots; redaction policy applied)
Stack          (Leaflet, Apps Script, Google Sheets, etc.)
Constraints    (consent, naming, retention notes — not shown to viewer; for Brent)
```

### Step 2e — Asset capture sprint (run during this CCP)

Even though the portfolio doesn't go live, **capture is time-sensitive** because campaign sites are coming down. For each Chaka tool, run the BB-Notes per-tool checklist now:

- 30-60s screen recording of actual use
- Screenshots at multiple states (empty / populated / edge cases) at desktop + mobile
- Data export / JSON snapshot of end-of-campaign state
- Aggregate metrics
- Repo tagged at end-of-campaign state
- Signed IP letter filed durably
- Written code-retention OK from Chaka filed durably

Hand off the package to Brent. Store in BB-Notes (`notebooks/bw/portfolio-assets/<tool>/`) or a private repo — **not** the public site repo.

### Phase 2 deliverables

1. `bb-notes/notebooks/bw/portfolio-architecture-2026-05.md` — decision memo + recommended option.
2. `bb-notes/notebooks/bw/portfolio-content-template.md` — the case-study template.
3. Per-candidate safety-gate completion table.
4. Captured assets stored privately for the Chaka tools (and Julie scraper if appropriate).
5. A separate follow-up CCP (`CCPs/2026-XX-XX-bw-portfolio-launch.md`) drafted but **not executed** — that CCP is when the portfolio actually goes live.

---

## Constraints

- **Action gate stands.** Each phase: propose numbered list → stop → wait for "go." `/ultrareview` and the launch CCP are explicit later decisions.
- **Surgical edits.** Any v1.4.2 fix from Phase 1 punch list is small and targeted. No rewrite-the-world refactors.
- **Halff conflict firewall is non-negotiable.** No MMR, no Halff IP, no Halff client names, no AEC-firm framing leakage.
- **Default-deny on naming.** A client only gets named in any portfolio artifact (public OR private draft) after written consent is on file. Default to abstracted descriptors.
- **No portfolio HTML on the live site this round.** Phase 2 is design + capture. Going live is a separate decision under a follow-up CCP.
- **Capture is time-sensitive.** Chaka campaign sites have a finite lifespan; the per-tool capture checklist runs even if the portfolio launch is deferred.
- **No client outreach from this CCP.** Chaka testimonial / retention ask was already sent 5/14 — do not re-ping. Julie ask is timed for chaos to settle.

---

## Notes for Claude (CC session)

- Read `playbook/agents/<name>.md` before dispatching that agent. Cite the agent file in the dispatch prompt.
- For Phase 1, dispatch the four agents in **parallel** (single tool turn, multiple `Agent` calls).
- Synthesize agent findings yourself; do not ask another agent to synthesize unless `senior-product-review` is the one doing it explicitly (per its S1-S6 charter).
- For Phase 2, the deliverables are markdown documents. No HTML, no CSS, no `Edit` against `billington-works-site/index.html` in this CCP (Phase 1 punch list excepted).
- This CCP can be split across two sessions. Phase 1 in one session, Phase 2 in another. Don't try to compress both into a single context window — both phases warrant the full action gate.
- If Brent says "skip the launch CCP draft," just say so in the final report and don't fabricate the file.

---

## What good completion looks like

- v1.4.1 site has passed (or will pass after a small v1.4.2 patch) a documented multi-agent QA bar.
- Brent has a written portfolio architecture decision he can stand behind, signed off this week or next.
- Every Chaka campaign tool that was at risk of going dark has a private asset bundle captured before that happens.
- Per-candidate safety gate is filled out so the eventual launch CCP is unambiguous — for each case study, "yes / no / waiting on X" is on paper.
- A follow-up CCP exists for the actual portfolio launch, ready to be executed when consents firm up.

## What NOT to do

- Don't ship the portfolio live in this CCP.
- Don't name Chaka, Gala, or Julie in any public artifact without the documented consent gate cleared.
- Don't pull the trigger on `/ultrareview` from inside the agent loop — that's a Brent-initiated command.
- Don't capture Halff-related tooling (MMR or otherwise) as portfolio material.
- Don't rewrite the site under the banner of "Phase 1 cleanup." Surgical fixes only; bigger changes get their own CCP.
- Don't compress both phases into one session unless the punch list from Phase 1 is empty.
