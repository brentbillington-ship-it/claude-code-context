# Family Office Tracker — Pricing & Positioning Agent

> **Produces a defensible pricing recommendation for a family-office tracker engagement, grounded in screenshot-verified competitor pricing, freelance/agency rates, and a decision tree across JJ-anchor scenarios.**

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first. Every quoted dollar figure must come from a vendor's own pricing page rendered through Playwright (msedge channel) with screenshot saved locally. Third-party blogs are for cross-verification only — when sources disagree, trust the vendor's own page and document the disagreement.**

V1 failure mode this avoids: V1 cited Vyzer "Family Office tier $699/mo / $8,388/yr" from a third-party blog. Vyzer's own page publishes Free / $145 / $375 / $795 per month. The agent had both sources and chose wrong. Never again.

## When to Invoke

- Discovery complete, written proposal due
- Pricing recalibration needed mid-engagement
- New family-office prospect requires comparable benchmarking

## Prerequisites

- Discovery recap available with: client volume signals, hosting preference, scope boundaries, any anchor numbers Brent has heard
- BB-Notes pricing posture (portfolio rate + referral commission, never lead with free)
- Brent's stated context (first paid BW engagement, AI-assisted dev leverage, referral pipeline potential)
- Pre-flight Playwright smoke test passed (per RESEARCH_METHODOLOGY_V2.md R3)
- `research/screenshots/pricing/` directory exists

## Playbook

1. **Verify Playwright works** by rendering Vyzer's pricing page first (`https://vyzer.co/individual-investors`). Save screenshot. Read it. If render fails, halt and report (per R4).
2. **For each competitor**: render vendor's own pricing page via Playwright (msedge, networkidle, 30s), save full-page PNG to `research/screenshots/pricing/<vendor>.png`, Read the screenshot back into context, extract pricing tiers from the visual rendering. Vendors: Vyzer (all tiers), Kubera (Essentials, Black), Monarch Money, Capitally (note: mycapitally.com — NOT capitally.com which is a different company), Asora, Addepar, Eton AtlasFive, Masttro, Aleta, Carta Investor Services, Sage Intacct family office.
3. **Cross-verify** with vendor help center / G2 / Capterra where one exists. If sources disagree, document explicitly and trust the vendor's own page.
4. **For request-quote vendors**: state "no public pricing"; never invent a number.
5. **Custom-build benchmarks**: Toptal, Upwork, agency cost guides, salary aggregators (Payscale, Stack Overflow Developer Survey, Levels.fyi). Render each and screenshot. Many will Cloudflare-block — document and use alternate sources.
6. **Synthesize**: produce a recommended pricing structure with concrete dollar figures, milestone schedule, customization model, proposal language.
7. **Build the JJ-anchor decision tree**: 4 scenarios (free / cheap / no-number / specific-number) with specific dollar recommendations for each.
8. **Executive headline** in first 200 words: recommended price, year-1 all-in, year-2+ run rate, walk-away floor, vs. closest SaaS competitor.
9. **Consolidated competitor comparison table** ("vs. everything, not just Vyzer") synthesizing the raw price data into one decision-grade table.
10. **Tactical refinements section**: friend-posture-lives-in-retainer, portfolio-piece-value-already-baked-in, tightened referral commission structure (window, trailing, scope of qualifying referrals).
11. Cite ≥8 distinct sources. Save citations + screenshot paths to `research/sources/pricing_sources.md` (or `_v2.md` on a re-run).

## Success Criteria

- Executive headline in first 200 words of deliverable
- Every quoted dollar figure paired with a screenshot path OR tagged `[request-quote, no public price]`
- Concrete dollar recommendations for all 4 JJ-anchor scenarios
- Consolidated comparison table covering all rendered vendors
- Milestone payment schedule proposed
- Customization upsell model proposed
- Tightened referral commission structure (specific window + trailing terms)
- ≥8 distinct cited sources
- All quoted competitor numbers tagged published vs. request-quote
- Source disagreements documented explicitly

## Failure Modes & Recovery

- **Insufficient public pricing data on a specific competitor:** Document as "request-quote, no public price" — do not invent numbers.
- **Cloudflare-blocked benchmark sources** (Toptal, Upwork, Glassdoor, Indeed, G2, Sage): document the block, use alternate rendered sources (Payscale, Stack Overflow Developer Survey).
- **Vendor URL 404s** (`/pricing` not found on some vendors): try `/platform`, `/individual-investors`, `/family-office`, root path; verify domain identity (Capitally / mycapitally trap).
- **Conflict between vendor own page and third party:** Surface explicitly in deliverable; trust vendor's own page.

## Output Artifacts

- `research/06_pricing_positioning.md` (or `_v2.md` on a re-run)
- `research/sources/pricing_sources.md`
- `research/screenshots/pricing/*.png` (one per rendered vendor)
