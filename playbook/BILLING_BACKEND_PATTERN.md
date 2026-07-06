# Billing-Backend Routing — the ApiBackend / CodeBackend pattern

A reusable pattern for any pipeline that calls Claude and can run both
interactively and automated.

## The pattern

Two interchangeable backends behind one contract:

| | ApiBackend | CodeBackend |
|---|---|---|
| Auth | `ANTHROPIC_API_KEY` env var | Claude Code OAuth (Max subscription) |
| Billing | Per-token, metered API credits | Flat subscription |
| Speed | ~2–5 s/chunk | ~15–30 s/chunk (subprocess overhead) |
| Best for | CI, GitHub Actions, shared machines, scheduled/automated runs | Personal machine, manual high-volume batches |

Routing priority (highest wins): env var (`LLM_BACKEND`) → runtime state
file written by the launcher → config constant default.

## The load-bearing safeguard: key stripping

The CodeBackend must **explicitly strip `ANTHROPIC_API_KEY` from the
subprocess environment** before invoking `claude -p`. Otherwise an
ambient shell key silently re-routes subscription work onto metered
billing — the failure is invisible until the invoice.

Corollaries:
- The stripping only protects subprocesses the pipeline spawns. A manual
  `claude -p` in a shell that has the key set WILL bill metered.
- A parity test (same input through both backends, diff the output)
  belongs in the repo so backend switches are provable, not vibes.

## Choosing per run

- Manual / attended / iterative → CodeBackend (subscription; marginal
  cost ≈ 0).
- Scheduled / unattended / other machines → ApiBackend with a scoped key
  and a spend cap, so a runaway loop hits a ceiling instead of a card.
- Never let "which backend" be implicit: the launcher surfaces the active
  backend in its UI, and logs it per run.
