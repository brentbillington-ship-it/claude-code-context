# Family Office Tooling — Cross-Project Reference

*Generalizable findings from the Gala Holdings Tracker research run (2026-05-05). Reusable across future family-office, wealth-tracking, finance-dashboard, and high-net-worth-tooling engagements. Specifics are kept private to the engagement repo; this file holds patterns that survive client boundaries.*

---

## Pricing landscape (2026)

Useful anchors when scoping any custom build for a wealthy individual / family office / RIA.

### SaaS competitor anchors (published)

- **Vyzer Family Office tier:** ~$699/mo on annual plan = $8,388/yr. Multi-tenant SaaS. Often the tool being compared to in family-office conversations.
- **Vyzer Premium personal:** ~$240/yr published.
- **Kubera Essentials:** $249/yr. Net-worth tracker, light on fund/PE features.
- **Kubera Black:** $2,499/yr. Adds beneficiary access, premium support.
- **Monarch Money:** ~$99/yr personal household.
- **Capitally Navigator:** ~€130/yr (~$140/yr).
- **Visible.vc:** Founder-side, not LP-side; pricing varies by funds tracked.

### Enterprise/family-office tier (request-quote, third-party estimates)

- **Addepar:** Often cited at $50K-$150K+/yr for a family office, scales with AUM bps.
- **Eton AtlasFive:** Similar enterprise tier; published comparables suggest mid-five to six figures.
- **Asora:** Not publicly priced; targets multi-family offices and wealth managers.
- **Carta Investor Services:** GP-side investor portal; pricing tiered by fund size.
- **Sage Intacct family office:** Accounting-platform anchor; not a tracker per se but the closest enterprise comparable.

### Custom-build market rates (2026, US-based, senior full-stack)

- Upwork senior full-stack: typical $90-$180/hr.
- Toptal: $150-$250/hr.
- Agency fixed-bid for "small business operational tool with dashboard": $25K-$60K is the typical range; below $20K is hard to commit to honestly without AI leverage.
- Solo developers with AI leverage: can deliver 200-hour-equivalent scope in 80-130 actual hours. Pricing reflects delivered value, not hours.

### Useful pricing posture for a brand-new freelance brand

- **One-time build + maintenance retainer** beats SaaS subscription for single-tenant builds. Aaron-anchor pattern: "no five figures annually" — easily met by amortizing the build into year-1 and keeping retainer steady-state under $5K/yr.
- **30/30/40 milestone payments** (signed scope / prototype demo / production delivery) align fixed-bid risk between vendor and client.
- **Walk-away floor matters more than ceiling.** First-engagement pricing precedent damages every future deal if set too low. Define and hold a floor.
- **Referral commissions** (10-15% first-engagement, 12-month window) are the right structure for "free" or near-free recovery scenarios.

---

## Family office product patterns

### What every family-office tool tries to do

1. Investment record CRUD with stage/sector/instrument enums
2. Transaction logging (positive amounts with type-interpreted sign is the standard pattern)
3. Valuation marking with method (Priced Round / 409A / NAV / Comparable / Internal Mark)
4. Returns metrics: MOIC, DPI, RVPI, TVPI, XIRR
5. Document storage attached to assets

### What most tools do POORLY (white-space candidates)

1. **Auditable XIRR with cash-flow drill-down.** Most tools show a number, not the inputs. Sophisticated principals (Raj-class) want to verify against their own model.
2. **Expected-vs-actual at the deal level.** Almost no tool surfaces this natively. The dumbbell-chart-per-deal pattern is a clean win.
3. **K-1 status board with auto-populated expectation by instrument type** (partnership → expected; C-corp → not expected). Vyzer is the only confirmed competitor with K-1 tracking; Vyzer is multi-tenant and expensive.
4. **Debt / LOC as a first-class credit-facility module.** Every tool either ignores debt or treats it as a liability balance. A real credit-facility module (limit, drawn, available, interest accrual, payment history) is genuine white-space.
5. **Single-tenant deployment with full data isolation.** Every SaaS competitor is multi-tenant. For family offices, single-tenant is a security/control differentiator unavailable below enterprise custom arrangements.
6. **Calc transparency.** Every metric clickable to inputs. SaaS competitors can't match without rebuilding their data model.

### Schema patterns that survive (port these, do not invent)

- `_Lists` reference table for enums (Instrument, Stage, Status, Sector, TxnType, ValMethod, Scenario)
- `Investment` keyed by an Investment ID, with calculated columns flowing up from Transactions and Valuations (do not store calculated values; compute on read)
- `Transaction` with positive amounts and type-interpreted sign (Contribution / Distribution / Fee). Add `Fee Subtype` (Placement / Management / Carry / Legal / Other) for net-of-fee math.
- `Valuation` with method enum and date — use date-ordered query for "latest mark," NOT the Excel `LOOKUP(2,1/...)` reverse-lookup pattern (fragile, returns last row not latest date)
- `Projection` with year + scenario + probability — validate sum-to-≤1.0 per (investment, year)
- `K1Record` separate entity: (Investment, Calendar Year, Status enum, File URL, Notes)
- `DebtFacility` separate entity: (Name, Type, Credit Limit, Drawn Balance, Interest Rate, Payments)
- `Entity` foreign key on every record — even single-tenant v1 should have it for multi-entity v2 forward-compat

---

## Finance methodology — quick reference

Always cite primary sources, never invent. The canonical anchors:

- **ILPA Performance Template** — granular methodology for MOIC/DPI/RVPI/TVPI/IRR
- **ILPA Capital Call & Distribution Template** — drawdown accounting
- **CFA Institute "Time's Up for the IRR"** — XIRR vs IRR critique, when each applies
- **AICPA Valuation of Portfolio Company Investments Guide** — valuation method conventions
- **IRS Schedule K-1 (Form 1065) Instructions** — K-1 mechanics
- **scipy.optimize.brentq** — canonical XIRR root-finding implementation; Newton fallback for edge cases (multiple sign changes, near-singular)

XIRR validation must hit 4-decimal precision against Excel's native XIRR before any demo to a finance-fluent principal. Excel uses Newton-Raphson with a default initial guess of 0.1; brentq uses bracketing — outputs converge to the same root for well-conditioned inputs.

---

## UI patterns for finance dashboards (2026)

Validated across Monarch, Vyzer, Kubera, Asora, Addepar, Linear, Vercel, Stripe Dashboard, Carta, Copilot Money, Lunch Money:

1. **Collapsible left sidebar as primary chrome** (256px expanded / 64px collapsed) with localStorage persistence
2. **Macro-to-micro widget dashboard** — KPI strip → composition → table; per-user persistent layout
3. **Right-aligned numeric columns with `tabular-nums`** — non-negotiable when sophisticated principals are reading
4. **Persistent contextual action bar** for bulk operations (Lunch Money / Monarch pattern)
5. **Role-based progressive disclosure** — same data, different defaults per role (Asora / Vyzer / Addepar)
6. **Skeleton loading + inline empty states** — avoid spinner-on-empty-table feel
7. **Neutral chrome with single semantic accent** — warm grays beat cool grays for long sessions; reserve a second accent for warnings
8. **Annotated time-series with event markers** — for single-investment narrative views
9. **Sortable data table with sparklines + conditional formatting** — Few's table-beats-chart for multi-attribute lookup
10. **Macro temporal navigation** — period selector + "today" markers; single-source-of-truth filtering

### Tech stack (2026 default for this category)

- Next.js (App Router) + TypeScript + Tailwind + shadcn/ui
- Recharts as default; Visx or D3 for niche chart types (dumbbell, waterfall, treemap with custom labeling)
- Prisma + PostgreSQL
- NextAuth + Microsoft Entra ID (most family-office clients are M365-aligned)
- Azure App Service or Render Pro for single-tenant hosting

---

## Data viz principles (for finance dashboards)

Anchored in Tufte / Munzner / Cairo / Few:

- Tufte: maximize data-ink ratio; prefer tables over charts for multi-attribute lookup; small multiples for scenario comparison
- Munzner: validation across abstraction → idiom → algorithm levels; channel ranking (position > length > angle > color)
- Cairo: function before decoration; honesty over impressiveness
- Few: bullet graphs for KPI vs target; dashboards must fit on a single screen for at-a-glance use

### Chart-type-to-use-case mappings (for finance dashboards)

| Use case | Chart type | Why |
|---|---|---|
| Returns metrics summary | Sortable table + sparklines + conditional formatting | Multi-attribute lookup; tables beat charts here |
| Actual vs expected MOIC | Dumbbell chart | Two data points per category, gap is the message |
| K-1 status (year × investment) | Color-coded grid / heatmap | Categorical status across two dimensions |
| Capital drawdown | Stacked bar per fund + waterfall portfolio | Per-fund composition + portfolio narrative |
| Portfolio composition | Treemap (primary) + grouped horizontal bar (drill) | Part-to-whole with hierarchy |
| Time-to-liquidity | Horizontal bar (Gantt) with "today" marker | Duration on shared time axis |
| Scenario projections | Small multiples or fan chart with explicit envelope label | Mutually exclusive futures, never additive |
| Single-investment timeline | Annotated time series (FMV + cost basis + markers) | Narrative form |
| Net worth over time | Line chart with period selector | Aaron-style "how are we doing" question |
| Winner/loser surfacing | Pareto (sorted bar + cumulative line overlay) | "X% of deals produce Y% of returns" question |

### Failure modes to avoid

- Pie charts for >3 categories (always)
- Stacking mutually exclusive scenarios in one bar
- Hiding negative periods by truncating axes
- Sparklines without shared scale
- More than 3-4 status colors in a heatmap
- Amber/green pairing without secondary encoding (color-blind risk)
- Treemap labels under ~5% allocation (collapse into "Other")

---

## Style guide patterns

- **Typography:** sans-serif for chrome (Inter, Geist), monospace with tabular figures for numbers (JetBrains Mono, IBM Plex Mono). Tabular figures non-negotiable for finance.
- **Color palettes:** 7-color categorical scale for charts; semantic tokens for primary/surface/text/border/accent/success/warning/danger; light + dark mode from day 1; WCAG AA on body text (4.5:1 minimum) is the floor.
- **Spacing:** 4px or 8px base scale; table row heights 40-44px for tabular-figure scannability; never go below 32px row height for finance tables.
- **Density:** consider a density toggle when a single tool serves both a sophisticated principal (wants every column) and an operator (wants clarity).
- **Iconography:** Lucide is the de-facto default with shadcn; Heroicons is an Apple-aligned alternative.

---

## Process patterns for solo dev consulting

These show up across BW engagements regardless of vertical.

- **Discovery → research → proposal → build** is a 4-week cadence at the smallest. Don't compress.
- **Research is compressible with Claude Code subagents** — 5-6 parallel agents on a Tuesday night replace 2 weeks of solo desk research.
- **Brainstorm before any non-trivial work.** Superpowers Brainstorm skill, output to a `research/00_brainstorm.md` or `docs/specs/...-design.md`.
- **Pricing decision tree** — model what the connector might have anchored to; have a recovery plan for each scenario.
- **Walk-away floors are non-negotiable** — set them, document them, hold them.
- **Math validation against the source spreadsheet** is the gate before any demo to a finance-literate principal.
- **NDA before real data flows.** Synthetic test data only until signed.

---

## When to reuse this file

- New family office or wealth tracker engagement
- Custom CRUD admin tool with finance dashboard
- Any engagement involving XIRR, MOIC, DPI, RVPI, or PE drawdown accounting
- Any engagement where the principal user is a sophisticated finance professional who will check the math
- Pricing a new freelance engagement when family-office or wealth comparable anchors are useful

---

*Source: Gala Holdings Tracker research run, May 2026. Specific client details remain in the engagement repo. Generalizable patterns, references, and anchors live here.*
