# Research-Agent Bootstrap

> **Pre-flight gate for any session that dispatches research agents at external products, sites, or competitor UX. Read before writing the first agent prompt. Created 2026-07-02 from the BB-Notes 2026-05-07 proposal, updated for the allowlist fix that proposal predated.**

## Why this file exists

Two research runs failed the same way. Gala V1 (2026-05-05) wrote a CCP that forbade the only methodology that works and shipped text-inference dressed as visual findings, including an invented Vyzer pricing tier. BB-Notes (2026-05-07) burned a session rediscovering the sandbox network and committed 28 PNGs of proxy deny pages believing they were screenshots. Both failures were pre-flight failures: nobody checked what the environment could actually reach before dispatching agents whose methodology depended on it.

## Step 1 — Know your environment

Read CCC standing rules § "Sandbox / Network" (Environment Matrix). Name which environment the session is in before writing any CCP. The remedies differ:

- **ThinkPad local CLI:** allowlist is widenable in `.claude/settings.local.json`, restart required.
- **claude.ai/code container:** most external hosts are blocked at the network layer. Widening may be available via the environment's network policy or `settings.local.json`, restart required. WebFetch/WebSearch ride Anthropic's egress and reach blocked domains, but return text, not pixels.
- A settings change without a session restart does nothing. Do not conclude "still blocked" from a mid-session edit.

## Step 2 — Probe before dispatch (REQUIRED)

```bash
for h in <every domain the research needs>; do
  code=$(curl -s -o /dev/null -w "%{http_code}" -m 8 "https://$h" 2>&1)
  echo "$h => $code"
done
```

If any target returns 403/000:
1. Widen the allowlist for those domains and restart, then re-probe.
2. Only if widening is unavailable or fails: switch methodology (Step 3) BEFORE dispatch. Do not write a CCP that hard-requires rendering hosts the probe says are unreachable.

## Step 3 — Methodology decision tree

| Need | Method |
|---|---|
| Visual claims about an external app's UI | **Playwright render + screenshot + Read-back is the primary method (R1).** Widen the allowlist to make it possible. WebSearch reviewer summaries are cross-validation only, never the primary source for a visual claim. If rendering is truly impossible in-session, hand the render pass to the ThinkPad and have artifacts dropped into `research/screenshots/` before synthesis. |
| Pricing facts | Vendor's own pricing page, rendered and screenshot-captured (R2). No public price means "request-quote", not an invented number. |
| Docs for an open-source project | `curl https://raw.githubusercontent.com/<org>/<repo>/main/README.md` and friends. Tag OBSERVED-VIA-DOC. |
| Reddit / HN / practitioner threads | WebSearch with the site or subreddit in the query. Indexed text is fine for text claims. Mark proxy-sourced claims "(proxy)". |
| Academic papers | WebSearch + DOI citation. Most publisher fetches 403. |

## Step 4 — Verify artifacts before committing

Every screenshot pass ends with a verification step: check file sizes and Read at least one image back per batch. A 403 deny page renders as a real PNG. The BB-Notes session committed 28 of them. If the Read-back shows "Host not in allowlist" or similar, the whole batch is suspect.

## Step 5 — Log what you learned

Append a dated line to the reachability log below whenever a session observes an allowlist delta. This log is the institutional memory that keeps the next session from re-running the same probes blind.

### Sandbox reachability log

- 2026-05-05/06 (Gala research V2, claude.ai/code): WebSearch + URL-cited methodology produced a defensible audit without rendering. No allowlist widening attempted.
- 2026-05-07 (BB-Notes v2, claude.ai/code): network-namespace proxy confirmed. Reachable: github.com/raw/api, registry.npmjs.org, pypi.org, api.anthropic.com. Blocked: `*.github.io`, vendor marketing domains, Wayback, Reddit, Wikipedia, YouTube, Google, DuckDuckGo, most apt PPAs. WebFetch fails like curl; WebSearch works. (Predates the settings.local.json widening discovery.)
- 2026-05 (BB-Notes, later sessions): `.claude/settings.local.json` `sandbox.network.allowedDomains` + session restart successfully widened the allowlist to 9 competitor marketing domains. This supersedes the 05-07 "unfixable" conclusion.
- 2026-07-02 (CCC harness review, claude.ai/code remote container): `github.io`, `reddit.com`, `news.ycombinator.com` blocked (000); `www.anthropic.com`, `docs.anthropic.com` 403 via proxy; `registry.npmjs.org`, `pypi.org` 200; `code.claude.com` reachable. WebFetch/WebSearch (agent egress) reached all research targets, including Anthropic docs.
