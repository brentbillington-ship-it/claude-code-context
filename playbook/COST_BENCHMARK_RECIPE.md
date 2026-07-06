# LLM Cost Benchmark — the per-unit sampling recipe

Promoted 2026-07-06 from the MMR pipeline cost benchmark
(`Halff-Citizen-Devs/Municipal-Market-Dashboard` issue #52, verified
same-day by an independent estimate pass). Use whenever someone asks
"what does this pipeline cost to run" — the answer is a measurement, not
a guess.

## Recipe

1. **Pick the natural work unit.** For MMR it's one council meeting; for
   another pipeline it's one document, one ticket, one page.
2. **Sample recent reality, not synthetic input.** 5 most-recent units
   per client/segment, pulled from the stored artifacts the pipeline
   actually processed.
3. **Reproduce the pipeline's own extraction path locally** (same
   library, same fast-paths) and count tokens on the true payload —
   including the system prompt, WHICH IS RE-SENT ON EVERY CALL
   (MMR's 4.8k-token prompt times dozens of calls per meeting dominated
   several clients' cost).
4. **Extrapolate by cadence**, per segment: per-unit tokens × units per
   month. Estimate tokens at ~3.7 chars/token and state the error bar
   (±10–15%).
5. **Price at metered API rates as the upper bound**; note that
   subscription-backed runs make the marginal cost ≈ 0 (see
   `BILLING_BACKEND_PATTERN.md`).
6. **State exclusions explicitly** — one-time build/backfill cost,
   disabled segments, importers that bypass the LLM step.
7. **Name the levers before anyone asks:** prompt caching (~90% off
   cache reads — the fix for the re-sent system prompt) and Batch API
   (50% off) — note whether they're enabled and at what volume they'd
   matter.

## Benchmark result to beat (MMR, 2026-07)

28 PDF-extraction clients ≈ 14.2M tokens/month ≈ $0.51/client/month at
Haiku metered rates (~$14/mo fleet). Biggest drivers: monolithic FL
packets and item-heavy cities re-sending the system prompt per item.
Refresh via the recipe above; the issue #52 thread carries
`UPDATING-THE-ESTIMATE.md`.
