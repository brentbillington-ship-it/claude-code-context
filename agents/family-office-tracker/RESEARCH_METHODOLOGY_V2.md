# Family Office Tracker — Research Methodology V2

> **Canonical methodology for all family-office tracker research agents. Supersedes any V1 methodology described in individual agent files. Every agent in this directory reads this file before spawning research work.**

**Status:** Authoritative as of 2026-05-06. Written after V2 research re-run on the Gala Holdings Tracker engagement, where V1 methodology produced compromised deliverables (invented Vyzer pricing tier, inferred-from-text aesthetics review with zero rendered UIs, conflated vendor identity).

---

## Why V2 exists

V1 methodology (May 2026) produced 5+ compromised deliverables in ~1 hour:

1. **Pricing** cited Vyzer's "Family Office tier $699/mo / $8,388/yr" from a third-party blog. Vyzer's own help-center publishes Free / $145 / $375 / $795 per month. The agent had both sources and chose wrong.
2. **Aesthetics** was inferred from marketing-copy text. No agent rendered any competitor UI. The deliverable was vibe-inference dressed as findings.
3. **Data Viz** had the same flaw — chart claims about Monarch / Vyzer / Kubera with no visual rendering of the products being described.
4. **Capitally** was conflated with Capitally Finance Corp (Canadian funding firm); the portfolio tracker is at mycapitally.com — two different companies.
5. **CCP** explicitly forbade screenshot capture, removing the only methodology that would have worked.

CCC standing rules R1-R6 in `CLAUDE_CODE_STANDING_RULES.md` codify the fix. This document operationalizes them for the family-office tracker agent roster.

---

## R1 — Visual claims require visual rendering

If a deliverable will assert anything about a vendor's UI, dashboard layout, chart design, color usage, or visual pattern, the agent MUST:

1. Render the actual page through Playwright using Edge channel.
2. Save a full-page screenshot locally to `<repo>/research/screenshots/<bucket>/<vendor>/<page>.png`.
3. Use the **Read tool on the screenshot file** so the screenshot enters agent visual context.
4. Only after seeing the rendered output does the agent write observations.

WebFetch returns text. It cannot see UI. On JS-heavy marketing pages it often returns near-empty content the agent will fill with training-data guesses dressed as findings. Never use WebFetch for visual claims.

---

## R2 — Pricing facts come from vendor own pages, not third-party blogs

Every quoted dollar figure must come from one of:

- (a) The vendor's own pricing page, rendered through Playwright, screenshot saved to `screenshots/pricing/<vendor>.png`, OR
- (b) Tagged "request-quote, no public price" with no invented number, OR
- (c) Cross-verified against a second independent source AND the source disagreement noted explicitly in the deliverable.

When sources disagree, **trust the vendor's own page over any third party.** The Vyzer failure happened because the agent saw both vendor's help-center page AND a third-party blog and picked the blog. Never again.

---

## R3 — Pre-flight gate research runs with a Playwright smoke test

Before spawning research agents, the orchestrator (MANAGER agent) runs:

```bash
py -c "from playwright.sync_api import sync_playwright; \
p = sync_playwright().start(); \
b = p.chromium.launch(channel='msedge', headless=True); \
page = b.new_page(); \
page.goto('https://example.com', wait_until='networkidle', timeout=30000); \
import os; os.makedirs('C:/tmp', exist_ok=True); \
page.screenshot(path='C:/tmp/smoke.png', full_page=True); \
print('OK', page.title()); \
b.close(); p.stop()"
```

Expected output: `OK Example Domain`. If smoke fails, halt and notify Brent — don't burn budget spawning agents whose tool dependency is broken.

---

## R4 — Per-agent verification gate

The first vendor page each research agent visits MUST successfully render and screenshot before the agent continues to others. If Playwright fails on the first vendor, document the failure and notify — don't keep going on agents whose entire methodology depends on rendering they can't do.

---

## R5 — Sources contradict — document and trust the primary

When a third-party article and a vendor's own published page give different numbers (pricing, feature gates, tier limits), the deliverable explicitly notes the disagreement and uses the vendor's own page. Do not pick silently.

---

## R6 — Don't forbid the only methodology that works

V1 CCP forbade screenshot capture; the Aesthetics agent had no fallback and produced text-vibe inferences. CCP authors own this failure as much as agents do. **Screenshots stay local** (no uploads, no URL embedding) but are **required** for visual/pricing/feature claims.

---

## Tooling — concrete patterns

### Playwright via Edge (msedge channel)

Chrome is NOT installed on Brent's machine; Edge IS. **Do not run `playwright install chromium`.** Use the already-installed Edge through the msedge channel.

```python
# render_pattern.py — canonical pattern to copy/adapt
from playwright.sync_api import sync_playwright

def render_and_screenshot(url: str, screenshot_path: str) -> tuple[bool, str]:
    """Returns (success, page_title_or_error)."""
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(channel='msedge', headless=True)
            page = browser.new_page(viewport={'width': 1440, 'height': 900})
            page.goto(url, wait_until='networkidle', timeout=30000)
            title = page.title()
            page.screenshot(path=screenshot_path, full_page=True)
            browser.close()
            return True, title
    except Exception as e:
        return False, str(e)
```

**Required parameters:**
- `channel='msedge'`
- `wait_until='networkidle'`
- `timeout=30000` (30 seconds)
- `headless=True` by default
- `viewport={'width': 1440, 'height': 900}` (consistent reference)
- `full_page=True` on screenshot

### After rendering: Read the screenshot

```text
1. Save to research/screenshots/<bucket>/<vendor>/<page>.png
2. Use the Read tool on the PNG file path
3. Now the rendered UI is in your visual context
4. Write your observations citing both URL and screenshot path
```

This is the step V1 missed. Saving the file is not enough — the agent must Read it back so it visually inspects the rendering before writing claims.

### Citation format

Every visual/pricing/feature claim cites both URL and screenshot path inline:

```markdown
Vyzer's top tier is **Elite at $795/mo** ([screenshot: pricing/vyzer_pricing_card.png],
source: https://vyzer.co/individual-investors).
```

### Common rendering failures (encountered during V2)

| Site / class | Failure mode | V2 workaround |
|---|---|---|
| Cloudflare-protected (Toptal, Upwork, Clutch, BLS, Glassdoor, Indeed, G2, Sage) | 403 / interstitial CAPTCHA | Use alternate sources (Payscale, Stack Overflow Developer Survey) for the same metric; document the block |
| Login walls (Monarch app, Vyzer dashboard, Carta LP portal, Vercel dashboard) | Redirect to `/login` | Cite YouTube product walkthroughs and third-party review screenshots; tag as such; never attempt logins |
| Anti-bot ("Press & Hold" — Seeking Alpha) | Press-and-hold CAPTCHA | Document, do not bypass |
| 404s on common URL shapes (`/features`, `/pricing` on some vendors) | Page doesn't exist at that path | Check root + feature-specific subpaths; some vendors use `/individual-investors`, `/platform`, etc. |
| Domain confusion (Capitally) | `capitally.com` is a different company | Verify domain identity before quoting |

---

## Repo layout for screenshots

```
<engagement-repo>/research/screenshots/
├── pricing/
│   ├── <vendor>.png
│   └── <vendor>_<sub-page>.png
├── aesthetics/
│   └── <vendor>/
│       ├── homepage.png
│       ├── dashboard.png
│       └── ...
├── dataviz/
│   └── <vendor>_<chart-name>.png
├── features/
│   └── <vendor>.png
└── finance/
    └── <source>.png
```

Per-vendor subdirectories under `aesthetics/` because each vendor has multiple pages there. Pricing/features stay flat (one page per vendor typically).

---

## Hard constraints (carry these into every agent prompt)

- **Playwright via Edge channel only** (`channel='msedge'`). Never `playwright install chromium`.
- `wait_until='networkidle'`, `timeout=30000`.
- Headless by default.
- **No login attempts.** No paywall bypass. No CAPTCHA solving.
- **Screenshots stay LOCAL.** Do not upload anywhere. Do not embed in URL parameters. No third-party hosting.
- **`py` not `python`** (Brent is on Windows).
- **No Halff / F&N / Leigh / Ryan content** in any deliverable.
- **NDA-grade caution.** No real client portfolio data; synthetic test data only.
- **≤15 word direct quotes** from any author or vendor; otherwise paraphrase.

---

## When this methodology applies

Every agent in `claude-code-context/agents/family-office-tracker/`:

- AESTHETICS — visual claims (mandatory rendering)
- DATAVIZ — chart claims (mandatory rendering)
- FEATURES — tier × feature cells (mandatory rendering)
- FINANCE — third-party metric citations (mandatory rendering); ILPA/CFA static PDFs may use WebFetch/Read directly
- PRICING — every dollar figure (mandatory rendering of vendor pricing page)
- SYNTHESIS — reads V2 deliverables; doesn't render directly but verifies upstream agents cited screenshots
- MANAGER — runs the smoke test before spawning; validates that downstream agents complied

---

## What good looks like

A V2-compliant deliverable has:
- Every visual claim paired with `[screenshot: <path>]`.
- Every pricing claim paired with a vendor-page screenshot OR tagged `[request-quote]`.
- Every feature-matrix ✓/✗ cell paired with a screenshot showing the claim.
- Source disagreements explicitly documented (vendor vs. third-party).
- A "rendering failures" section listing what couldn't be rendered and why.
- An executive headline in the first 200 words.

A V2-non-compliant deliverable has any of:
- Inferred-from-text claims about UI/charts.
- Pricing numbers without screenshot paths.
- "Probably" or "likely" language about visible properties.
- Citations of third-party blogs over vendor's own pages without disagreement notes.

---

*End methodology. Each agent file in this directory references this document. Do not duplicate the rules in agent files; just cite this one.*
