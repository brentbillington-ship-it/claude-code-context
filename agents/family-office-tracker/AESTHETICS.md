# Family Office Tracker — Aesthetics & UI Agent

> **Reviews UI/aesthetic patterns from screenshot-rendered competitor pages and best-in-class fintech/SaaS dashboards. Identifies which patterns to adopt for the v1 family office tracker UI.**

## Methodology

**Read `RESEARCH_METHODOLOGY_V2.md` in this directory first. Every aesthetic claim MUST be backed by a screenshot the agent actually viewed — render the page via Playwright (msedge), save the PNG, Read the PNG file path so the rendered UI enters visual context. Only after seeing the rendering do you write observations.**

V1 failure mode this avoids: V1 inferred UI quality from marketing-copy text via WebFetch. No agent rendered any competitor's UI. Deliverable was useless for design direction. **The "no image downloads" rule from V1 is reversed** — screenshots are required, stored locally only (no uploads).

## When to Invoke

- v1 design phase needs grounded UI direction
- Refresh on competitor UI as benchmarks evolve

## Prerequisites

- Pre-flight Playwright smoke test passed (per RESEARCH_METHODOLOGY_V2.md R3)
- `research/screenshots/aesthetics/` directory exists
- No login attempts; no scraping gated content

## Playbook

1. **Verify Playwright works** by rendering Monarch's homepage first. Save screenshot. Read it. If render fails, halt and report.
2. **Render multiple pages per deep-dive vendor** (3-5 pages each: homepage, pricing, feature pages, blog post showing dashboard). Save to `research/screenshots/aesthetics/<vendor>/<page>.png` (per-vendor subdirectories).
3. **Read each screenshot** before writing observations.
4. **Vendor coverage**:
   - Deep-dive: Monarch Money, Vyzer (multiple pages each)
   - Moderate: Kubera, Capitally (note: mycapitally.com), Asora, Linear, Notion, Vercel, Stripe, Copilot Money, Lunch Money
   - Public-only: Addepar, Eton AtlasFive, Carta investor-portal marketing
5. **For login-walled product UIs**: cite YouTube product walkthroughs and third-party review screenshots, tagged as such. Render the YouTube watch page if you cite it; do not embed videos.
6. **Per-vendor sections** documenting: typography (sans/serif, weight, scale), color palette (literal hex/RGB if pinpointable from screenshot, descriptive otherwise), density, navigation/IA pattern, hero/dashboard layout, evidence of personality vs. utility, observed quality bar. Cite screenshot path inline next to each claim.
7. **Cross-vendor patterns section**: what does the family-office tier all do? Consumer-fintech tier? Developer-tooling tier (Linear/Vercel/Stripe)?
8. **Recommendations for the build**: concrete typography/color/density direction grounded in specific screenshots ("aim for Linear-density navigation with Stripe's serif-headline restraint" — that level of specificity).

## Success Criteria

- Per-vendor sections with screenshot citations on every aesthetic claim
- Monarch and Vyzer get dedicated extended sections (multi-page coverage)
- Synthesis with prioritized adoption list grounded in screenshots
- ≥5 distinct cited sources
- No invented colors / fonts — if not visible in screenshot, write "unclear from screenshot"
- No copyrighted text reproduction (≤15 word direct quotes)

## Failure Modes & Recovery

- **Login wall blocks deep-dive on a tool**: cite public marketing + YouTube walkthroughs; mark internal screens "not visually verified"
- **Cloudflare CAPTCHA** (Lunch Money, Carta): flag as "not visually verified"; do not bypass
- **Vendor URL 404s** (`/family-office`, `/features` on some vendors): replace with `/product`, `/security`, `/about`, blog posts that show the UI
- **Tool's UI has changed since last review**: weight recent walkthroughs higher; cite render date

## Output Artifacts

- `research/01_aesthetics_review.md` (or `_v2.md` on a re-run)
- `research/screenshots/aesthetics/<vendor>/*.png`
