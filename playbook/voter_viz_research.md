# Voter Viz Research — CISD Early Voting Tracker

**Purpose:** Pre-loaded research brief for the Phase 2 step of the Early Voting Tracker full-review workflow (see `CCP_early_voting_tracker_full_review.md`). CC should read this before proposing chart/viz additions so it doesn't have to re-research from scratch.

**Date compiled:** 2026-04-24
**Compiled by:** Claude (in Claude.ai, using web_search + synthesis)
**Next review:** After 2026-05-02 CISD Place 5 election, roll lessons into `/playbook/voter_viz_v2.md`

---

## 1. Framing — why this project is different from what shows up in search results

Most election viz online is **results-reporting** for national/statewide races: NYT, NBC, Reuters, 538 all build for the "who won, by how much, where" question with millions of voters and hundreds of counties. Our context:

| Dimension | National news viz | CISD Early Voting Tracker |
|---|---|---|
| Audience | Millions of readers | Campaign team + candidate (single-digit daily users) |
| Purpose | Inform / explain | Operate / decide (GOTV) |
| Universe size | Millions of voters | ~2,000 addresses, ~167 EV voters to date |
| Geographic scope | National / state | 11 precincts, one school district |
| Candidates | Many races, many candidates | Single race, 2 candidates |
| Update cadence | Once on election night | Hourly during 11-day EV window |
| Primary device | Desktop (reading) | Phone (field ops) |
| Key verbs | Read, compare, explain | Tag, target, act |

**Implication:** we should study campaign-side tools (TargetEarly, Ecanvasser, VoteBuilder, Impactive) more than news dashboards. The news-site patterns are useful for typography and numerical display, but the analytical framings should come from GOTV operations literature.

**Brent's distinctive data** that most tools don't have:
- Endorser flags per voter (rare — most tools only have voter file + contact history)
- Manual Chaka/Windham "pick" tagging from door conversations
- Tight precinct-level geography (11 precincts, not 3,000+ counties)
- Full voter universe (not just likely voters) from CISD voter file

This is where the portfolio value lives for Billington Works — most small-race campaigns don't get this level of instrumentation. The tracker is a reusable operating system for local races.

---

## 2. Reference sites — annotated

Sorted by relevance to our use case. CC can fetch these if it wants to inspect specific patterns.

### Tier 1 — Directly applicable (campaign-side, precinct-level)

**TargetEarly (TargetSmart)** — `targetearly.targetsmart.com`
Daily-updated dashboard of early/absentee voting, state and county level. Shows demographic breakdowns of who has vs. hasn't voted yet. **Steal:** the "already voted" vs. "likely to vote" framing; demographic filters as segment bar at top.

**UF Election Lab (Michael McDonald)** — `election.lab.ufl.edu`
Academic early-voting tracker with historical baselines. **Steal:** compact numerical summary tables, "compared to [prior election]" framing, sober color palette.

**Clark County NV EV data** — `clarkcountynv.gov/government/departments/elections/reports_data_maps/early-voting-turnout-data`
Raw-data-first election office site. Not beautiful, but shows the data model election offices actually expose. Useful to understand what Dallas County / Denton County probably provide.

**Ecanvasser / MiniVAN dashboards** (reference via marketing site `ecanvasser.com`)
Field-ops dashboards with canvasser leaderboards, contact rates, persuasion metrics. **Steal:** the leaderboard pattern for endorser productivity (if we ever add "endorsers who signed up voters").

### Tier 2 — News / results reporting (good aesthetic reference)

**NYT Elections (live results)** — Look for most recent election results page on nytimes.com
**Steal:**
- Huge, confident vote-count numbers at top
- "Last updated" timestamp prominently placed
- Small precinct map as a secondary element, not the hero
- Sparse use of color — two candidates, two colors, everything else greyscale
- "Estimated total vote" with forecast band (see below)

**FiveThirtyEight / ABC News election pages**
**Steal:** confidence bands (shaded area around forecast lines), clear labels inside the chart area (not just in legend), "chance of winning" as a percentage with big type.

**NBC News 2024 early voting map** — `nbcnews.com/data-graphics/2024-early-vote-data-map-rcna177666`
**Steal:** the "% of 2020 total vote" framing as a progress indicator — we should show "% of 2024 CISD Place 5 total vote" or similar baseline.

**Reuters / WSJ election graphics**
**Steal:** typography pairings (sans-serif for data, light serif for context), number formatting conventions (K/M shorthand).

### Tier 3 — Pure data viz references (for chart patterns)

**Flourish election templates** — `flourish.studio/resources/elections/`
Catalog of election chart types with live examples. Browse for inspiration, then recreate in Chart.js / D3 / Plotly.

**Observable election notebooks** — `observablehq.com/@observablehq/election`
Open-source D3 election viz. Useful if we want sophisticated custom charts; probably overkill for this project.

**Census Bureau voting visualizations** — `census.gov/topics/public-sector/voting/library/visualizations.html`
Dry but instructive demographic cut patterns.

### Tier 4 — Data viz design principles (general)

**Nuwan Senaratna, "How to Present Election Results" (Medium, 2024)**
Opinionated design principles specifically for elections. Key takeaways:
- Round percentages to whole numbers unless decimals matter (close race)
- Use K/M shorthand for large numbers — we don't have this problem, our universe fits in the hundreds
- Geographic maps can mislead — "in elections, individual votes matter, not land area"
- **Implication for us:** our map is fine (we're showing *voter locations*, not *area shading*), but if we add a precinct choropleth, make sure it's paired with a bar chart showing absolute counts

**Elections Group "Data Visualization Basics"** — `electionsgroup.com/resource/data-visualization-basics/`
Official-ish guidance for election administrators. Checklist of trust signals: "last updated" timestamp, data source attribution, clear methodology notes. We should do all of these.

**IFES Accessible Election Data Visualization** — `ifes.org/learning-series-disability-inclusive-election-technology/accessible-election-data-visualization`
Accessibility checklist. Most relevant: alt text on every chart, don't rely on color alone (also use shape/pattern/label), sufficient contrast ratios. Our site is probably not WCAG AA compliant — good candidate for a polish pass.

---

## 3. Current state of the tracker — what it already has

Based on recent commits and session context:

**Voter List** (table, sortable, filterable)
- Columns: First, Last, Endorsed, Chaka, Windham, Address, City, Date/Time
- Locked column order (do not change)
- Responsive: phone landscape hides Endorsed/Address/City/date-time portion; sort must key off ISO `v.date_voted`, not rendered text

**Map** (Leaflet, `preferCanvas: true`)
- Dots per voter, color by pick (Chaka / Windham / unknown)
- Clustering was removed last session (7c477c9), replaced with small offset-dots for shared addresses (3a53dc4)
- CISD boundary filter present but buggy (out-of-bounds voters appearing in Irving/Grand Prairie — Phase 1 diagnosis)

**Turnout chart**
- Form: likely a cumulative line / bar by day
- Polishing pass happened in 7c477c9 — specifics unclear without reading the code

**Admin affordances**
- Candidate pick buttons that POST to Apps Script (DO NOT auto-click)
- Cache-bust via version param in `docs/index.html` (currently `v=2026-04-23-15`)

**Data pipeline**
- `build_site_data.py` — reads voter file, geocodes, filters to boundary, writes `points.json`
- `geocoded.json` cache to avoid re-geocoding
- Census TIGER interpolation (known inaccurate, parcel centroid upgrade declined)

---

## 4. Proposed additions — ranked by impact × effort

Each item scored on a 1-5 scale. Impact = value to campaign operations or portfolio; Effort = implementation cost in hours.

### 4.1 Turnout pace vs. prior CISD elections (baseline band)

**What:** Cumulative turnout line chart with shaded bands for prior CISD May elections (2022, 2023, 2024, 2025). Current year's line overlaid in bold.
**Why:** Answers "are we on track?" — the single most useful operational question.
**Data needed:** Historical Dallas County EV files for prior May elections, filtered to CISD voters. You already know the parsing pattern (`header=1`, handle Excel serial + datetime, MM/DD/YYYY lookup).
**Chart type:** Chart.js line chart, dual-line with range fill plugin. X-axis = day of EV window (day 1, day 2, …, election day). Y-axis = cumulative voters.
**Mobile:** Works — line charts scale down to 390px fine if labels are abbreviated.
**Aesthetic:** Prior years as faint grey lines, baseline band as 10%-tinted grey, current year as bold red (#CC0000 — your Coppell Cowboys red works as the "now" color even outside Chaka context).
**Impact:** 5/5. **Effort:** 3/5 (data pull is the work). **Portfolio:** 5/5 — reusable for any race.

### 4.2 "Who's still out" — high-propensity non-voters list

**What:** Table/card list of voters in your universe who haven't voted yet, sorted by vote propensity score (you already have voting history). Filter by endorsed / precinct / distance-to-poll.
**Why:** Directly actionable for GOTV. This is the question every campaign manager asks at 4pm.
**Data needed:** Universe file minus voted list. Propensity = count of prior elections voted in (you have this). Optional: distance to Coppell EV location.
**UI:** Full-width responsive card grid on mobile, table on desktop. Each card shows name, address, precinct, last-voted date, endorsed-by indicator. Copy-phone-number button. "Mark contacted" toggle (local-only, no backend write unless you want it — we flagged backend writes as a guardrail).
**Mobile:** Essential — this IS the mobile use case. Canvassers pull it up on phones.
**Aesthetic:** Steal from task-manager apps (Things 3, Todoist). Avoid anything that looks like a political DB (VAN-style density feels invasive on mobile).
**Impact:** 5/5. **Effort:** 3/5. **Portfolio:** 5/5 — huge for Billington Works ("we build field-ops tools small races can afford").

### 4.3 Cumulative turnout with forecast band to Election Day

**What:** Same axis as 4.1 but extending past today into forecast territory. Linear regression from current pace + weight from prior-year end-of-window surge. Band = ±1 std error.
**Why:** Answers "will we hit our win number?" Turns descriptive data into decision support.
**Math:** Simple — project current pace forward with optional multiplier for last-day surge (typical in TX municipal). Use prior CISD elections to calibrate the surge factor.
**Chart type:** Extension of 4.1 — solid current-year line, dashed forecast line, shaded uncertainty band.
**Note:** UF Election Lab warns early-voting projection has high bias; be honest about uncertainty. Label the band "rough projection — not a poll."
**Impact:** 4/5. **Effort:** 2/5 (builds on 4.1). **Portfolio:** 5/5 — forecasting is sexy.

### 4.4 Endorser conversion rate

**What:** Simple 2×2 or stacked bar showing endorsed-and-voted / endorsed-not-voted / not-endorsed-and-voted / not-endorsed-not-voted.
**Why:** Measures whether your endorser strategy is actually moving voters. Rare metric — most campaigns don't instrument endorsements this way.
**Data needed:** Already have it — `endorsed` flag + voted status.
**Chart type:** Stacked horizontal bar, or 2×2 grid of big numbers with a percentage.
**Mobile:** Works great as big numbers.
**Aesthetic:** Stats-box style (think Stripe dashboard metric cards).
**Impact:** 4/5. **Effort:** 1/5. **Portfolio:** 4/5 — very distinctive.

### 4.5 Precinct-level dashboard cards

**What:** 11 precinct cards, each showing: turnout %, Chaka pick count, Windham pick count, endorsers voted, trend arrow vs. yesterday.
**Why:** Precinct-level operational detail. Captain-per-precinct model becomes natural.
**Data needed:** All already in points.json.
**UI:** Grid of 11 cards, 2-wide on mobile, 3-4 wide on desktop. Each card clickable to filter the map + voter list to that precinct.
**Mobile:** Works if cards are compact.
**Aesthetic:** Inspiration: Apple Fitness "activity rings" — small, glanceable, multi-metric in a tiny footprint.
**Impact:** 4/5. **Effort:** 3/5. **Portfolio:** 4/5.

### 4.6 Time-of-day voting distribution

**What:** Histogram of votes by hour (7am-7pm), cumulative across the EV window.
**Why:** Informs GOTV timing — if most voters hit 11am-1pm, that's when to door-knock reminders the night before.
**Data needed:** `date_voted` includes time if Dallas County file includes it. (Your memory says "DATE VOTED column arrives inconsistently" — may need to parse.)
**Chart type:** Simple bar chart, 13 bars (7am-7pm).
**Mobile:** Works at 390px if bars are thin.
**Impact:** 3/5 (interesting but rarely decision-driving). **Effort:** 2/5. **Portfolio:** 3/5.

### 4.7 Day-over-day delta ("who voted today that we hadn't tagged")

**What:** List of voters who voted in the last 24 hours but aren't tagged as Chaka or Windham. Actionable: means door conversation needed if they're in endorser network.
**Why:** Closes the loop between voter file and door-conversation tagging.
**Data needed:** Compare today's `points.json` to yesterday's snapshot.
**UI:** Simple list or table, one per day. Clickable to filter map.
**Mobile:** Essential use case.
**Impact:** 4/5. **Effort:** 3/5 (snapshot diffing is new machinery). **Portfolio:** 5/5 — very distinctive.

### 4.8 Pick rate by precinct × day

**What:** Heat map or small-multiples line chart showing Chaka/Windham pick rate by precinct over the EV window.
**Why:** Identifies where your ground game is winning vs. losing conversations.
**Data needed:** All in points.json.
**Chart type:** Small multiples (11 mini line charts, 1 per precinct) OR a precinct × day heat map with diverging color (Chaka red → neutral → Windham other-color).
**Mobile:** Small multiples works as vertical scroll on mobile; heat map struggles.
**Impact:** 4/5. **Effort:** 4/5. **Portfolio:** 4/5.

### 4.9 Geographic cluster of picks (hex bin or kernel density)

**What:** Replace the dot-map view toggle with a hex bin or kernel density layer showing where Chaka-picks cluster vs. Windham-picks cluster.
**Why:** Privacy-protective AND more readable at district scale (dots get lost in dense areas).
**Chart type:** Leaflet.heat plugin (KDE) or D3 hex binning over the base map.
**Mobile:** Works well at 390px.
**Impact:** 3/5 (beautiful but not super actionable). **Effort:** 3/5. **Portfolio:** 5/5 — photogenic.

### 4.10 Early voting vs. projected Election Day share

**What:** Stacked bar or donut showing "of expected total turnout, X% has voted already, Y% still to come Election Day."
**Why:** Context-setting for the whole operation.
**Data needed:** Prior CISD elections' EV-vs-EDay share as baseline.
**Impact:** 2/5 (useful once, not daily). **Effort:** 2/5. **Portfolio:** 3/5.

---

## 5. Patterns to steal — typography, color, layout

### 5.1 Typography

**Number display (big metric cards):**
- Font: Inter or system-ui, weight 600-700, tracking -0.02em
- Size: 32-48px on mobile, 48-72px on desktop
- Label above the number (12-14px uppercase, letter-spaced, muted color)
- Supporting context below (14px, muted)
- Steal from: Stripe dashboard, Linear, Vercel analytics

**Tables:**
- Row height 44px minimum (iOS tap target)
- Monospace or tabular-nums for numeric columns (CSS: `font-variant-numeric: tabular-nums`)
- Subtle row stripe or hover state, not heavy borders

**Headings in data context:**
- Don't use more than 2 heading levels on a dashboard page
- Sub-dashboard titles at 16-18px, not 24-32px — data should dominate, not chrome

### 5.2 Color

**The Chaka/Windham palette problem:** red-vs-blue reads as partisan, which may or may not be the story you want. Options:

| Option | Chaka | Windham | Reads as |
|---|---|---|---|
| Red/blue | #CC0000 | #1E4C8C | Partisan (avoid) |
| Red/gold | #CC0000 | #D4A017 | School colors — safe |
| Red/teal | #CC0000 | #0D8B8B | Neutral modern |
| Coppell red + neutral | #CC0000 | #4A5568 slate | "Candidate 1 / Candidate 2" |

**Recommendation:** Red (Chaka, already your brand red) + gold/teal (Windham). Absolutely not blue — too loaded.

**Map colors:**
- Sequential for turnout rate (precinct choropleth): light cream → deep red
- Diverging for margin: Windham-gold → neutral grey → Chaka-red
- Dots on voter map: keep the 2-candidate color, plus a grey for "no pick yet"
- Unknown-pick dots should be the *smallest* and *lowest-contrast* so they don't visually dominate

**Chart colors:**
- Max 4 colors in any single chart. Use opacity and line weight for hierarchy instead of more hues.
- Grid lines at 10% opacity, not 30% — let data pop
- Annotation color (callouts, highlights) at a separate accent color (e.g. charcoal #1A202C)

### 5.3 Layout

**Above the fold on mobile:**
1. Big number: total voted / total universe, with %
2. Big number: days remaining in EV window
3. Sparkline of today vs. yesterday
4. "Last updated: X min ago"

Everything else below the fold.

**Desktop uses the space for side-by-side:**
- Left: summary metrics + voter list
- Right: map
- Below: charts in a 3-col grid

**Tabs vs. sections:**
- You already have tabs. Keep them minimal — 3-4 max. Anything more, use a dropdown.
- Phone landscape tab-thickness was fixed in 010d021 — preserve that.

### 5.4 Copy / microcopy

- "167 voters have cast ballots" beats "167/2,000 (8.35%)" — lead with human number, put ratio in subtext
- "Updated 4 minutes ago" in context, not "Last sync: 2026-04-24T16:32:01Z"
- Empty states: "No voters match your filter" with one-click clear, not a blank table
- Error states: "Couldn't load map tiles — [Retry]" not "TileError: 500"

---

## 6. Mobile-first constraints (390px wide)

This is the real constraint — CC should verify every addition works at 390px. Hard rules:

1. **Tap targets ≥ 44px** (iOS HIG, Apple's magic number)
2. **Readable body text ≥ 16px** (or iOS auto-zooms on input focus)
3. **Horizontal scroll = fail.** Tables must collapse to cards or have sticky first-column.
4. **Map controls ≥ 44px** and not clustered — Leaflet defaults are too small; use `zoomControl: false` and build custom.
5. **Charts ≤ 280px tall** so the chart isn't the whole screen
6. **Touch-hold menus** don't exist — no right-click assumptions
7. **Safari iOS rubber-banding** can overlap fixed headers — test scroll behavior
8. **No hover states** for primary interactions (you can keep them as "polish" but functionality must work on tap)

For your phone landscape mode (orientation:landscape, max-height:500):
- Hidden columns: Endorsed, Address, City, Date/Time portion. Sort still keys off ISO `v.date_voted`.
- Map should probably still render but with simpler interaction (bigger touch targets, no popups — tap-to-highlight instead)

---

## 7. Implementation cookbook — chart library + patterns

### Chart library choice
**Chart.js** if you want simple, familiar, <100KB.
**Plotly.js** if you want interactivity and you're OK with bigger bundle.
**D3** if you want custom / portfolio-quality. Heavy lift.
**ECharts** if you want lots of chart types out of the box and don't mind ~1MB.

**Recommendation:** Stick with Chart.js for turnout / endorser / time-of-day. Use Leaflet.heat for the density overlay. Only reach for D3 if you want a genuinely custom viz.

### Responsive chart pattern (Chart.js)
```javascript
const chart = new Chart(ctx, {
  type: 'line',
  data: { /* ... */ },
  options: {
    responsive: true,
    maintainAspectRatio: false,  // let the container control height
    plugins: {
      legend: {
        display: window.innerWidth > 768  // hide legend on mobile, label inline instead
      }
    },
    scales: {
      x: {
        ticks: {
          maxRotation: 0,
          autoSkip: true,
          maxTicksLimit: window.innerWidth > 768 ? 10 : 5
        }
      }
    }
  }
});

// Container sizing via CSS:
// .chart-container { height: 240px; } @media (min-width: 768px) { height: 320px; }
```

### Historical baseline band pattern (Chart.js)
Use the plugin `chartjs-plugin-annotation` + `chartjs-plugin-trendline`, OR build a fill-between using two line datasets with `fill: { target: '-1' }`. Example:

```javascript
datasets: [
  { label: 'Prior years high', data: priorHigh, borderColor: 'transparent', backgroundColor: 'rgba(0,0,0,0.05)', fill: '+1', pointRadius: 0 },
  { label: 'Prior years low', data: priorLow, borderColor: 'transparent', backgroundColor: 'rgba(0,0,0,0.05)', pointRadius: 0 },
  { label: '2026 Place 5', data: current, borderColor: '#CC0000', borderWidth: 2.5, pointRadius: 3 }
]
```

### "Who's still out" list pattern
- Client-side compute: universe.filter(v => !v.voted).sort((a,b) => b.propensity - a.propensity)
- Virtual scroll if > 200 rows (use `react-window` equivalent or just paginate)
- Sticky filter bar at top, sortable columns on desktop, card layout on mobile

### Storage / state
Memory says localStorage works for the non-artifact site (this isn't an artifact — it's a real GitHub Pages site, so localStorage is fine). Use localStorage for:
- "Mark contacted" toggles
- User's last-viewed precinct filter
- "Hide voters I've already seen" toggle

Don't use localStorage for anything that needs to sync across devices.

---

## 8. Anti-patterns — what to skip

- **Full-screen hero maps** — we already have a map issue, don't make it worse by making the map the whole page
- **Animated number tickers** — cute once, annoying after. Simple fade-in on update is enough.
- **Cluster markers** — you already killed these, don't let them creep back
- **Pie charts for 2 candidates** — a stacked bar or big number + big number is always better
- **Party-color assumptions** — this is a nonpartisan school board race; don't color code R/D even implicitly
- **Live auto-refresh every N seconds** — battery killer on phones; refresh on tab-focus instead
- **Voter PII on public URLs** — if anything public-facing exposes names/addresses, double-check that's intentional (memory says the site is protected by pw `1950` for other repos; confirm this repo's access model)
- **"Prediction" framing for forecasts** — call them "projections" and be honest about uncertainty. UF Election Lab research shows early-vote-only models have 100%+ bias.
- **DCAD parcel centroid upgrade** — Brent declined; do not revisit unless he asks

---

## 9. What to propose in Phase 3 (out of this research)

If CC follows the Phase 3 instructions, the output should include (at minimum) a **D. New features / viz** section with these items, scored:

| # | Item | Impact | Effort | Portfolio | Net |
|---|---|---|---|---|---|
| D1 | Turnout pace vs. prior CISD elections (§4.1) | 5 | 3 | 5 | **7** |
| D2 | "Who's still out" list (§4.2) | 5 | 3 | 5 | **7** |
| D3 | Endorser conversion rate (§4.4) | 4 | 1 | 4 | **7** |
| D4 | Cumulative turnout with forecast band (§4.3) | 4 | 2 | 5 | **7** |
| D5 | Precinct-level dashboard cards (§4.5) | 4 | 3 | 4 | **5** |
| D6 | Day-over-day delta list (§4.7) | 4 | 3 | 5 | **6** |
| D7 | Time-of-day voting distribution (§4.6) | 3 | 2 | 3 | **4** |
| D8 | Pick rate by precinct × day (§4.8) | 4 | 4 | 4 | **4** |
| D9 | Hex bin / density map (§4.9) | 3 | 3 | 5 | **5** |
| D10 | EV vs. Election Day share (§4.10) | 2 | 2 | 3 | **3** |

(Net = Impact + Portfolio − Effort)

**Recommended first push:** D3 (endorser conversion, ~1 hour), D4 (forecast band, ~2-3 hours), D2 ("who's still out", ~3-4 hours). These hit the highest net score and represent the most distinctive portfolio value for Billington Works.

**Second push (post-election, for the case study):** D1 with the full post-mortem baseline, D6 with historical diffing, D9 for the photogenic marketing screenshot.

---

## 10. Portfolio / Billington Works notes

Every viz above should be extracted into a reusable pattern for future local races. Suggested structure for the post-election write-up:

- **Case study:** "How we instrumented a school board race: real-time turnout, endorser conversion, and GOTV targeting for under $0 in software cost."
- **Reusable components:** the cumulative-with-baseline chart, the endorser 2×2, the "who's still out" list, the precinct cards. All of these become plug-and-play for the next race.
- **Data pipeline template:** the EV-file parsing (Dallas County format), the universe-minus-voted diff, the historical baseline pull.
- **What worked / what didn't:** be honest about Census TIGER geocode accuracy, cluster-marker misfires, mobile landscape edge cases.

The tracker itself is the portfolio piece. Ship it with confidence.

---

*End of brief. CC: use as reference during Phase 2 of the full-review workflow. Do not treat any recommendation here as pre-approved — still propose-first per standing rules.*
