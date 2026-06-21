# Place-5-Tracker — CHECKPOINT

## 2026-05-05 CT — Repo frozen post-election

CISD Place 5 election (May 2, 2026) concluded. Chaka won. Tracker is now static
— no further data collection, no further digests.

All scheduled GitHub Actions disabled by commenting out their `schedule:` /
`- cron:` blocks. `workflow_dispatch:` left intact on each so they can still be
triggered manually if a one-off rerun is ever needed.

### Workflows disabled

| File | Previous schedule | Purpose |
| --- | --- | --- |
| `.github/workflows/collect.yml` | Daily 11:59 PM CT | Apify + Anthropic social collector |
| `.github/workflows/collect_quick.yml` | Every 2 hours | Apify quick follower refresh |
| `.github/workflows/email_digest.yml` | Mondays 8 AM CT | Weekly Gmail digest |

### Links

- Place-5-Tracker PR: brentbillington-ship-it/Place-5-Tracker#5
- Branch: `claude/disable-election-workflows-BSmKq`
