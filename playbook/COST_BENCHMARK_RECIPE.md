# LLM Cost Benchmark — the per-unit sampling recipe

Use whenever someone asks "what does this pipeline cost to run" — the
answer is a measurement, not a guess.

## Recipe

1. **Pick the natural work unit.** One document, one ticket, one page,
   one meeting — whatever the pipeline processes as a repeatable unit.
2. **Sample recent reality, not synthetic input.** 5 most-recent units
   per client/segment, pulled from the stored artifacts the pipeline
   actually processed.
3. **Reproduce the pipeline's own extraction path locally** (same
   library, same fast-paths) and count tokens on the true payload —
   including the system prompt, WHICH IS RE-SENT ON EVERY CALL
   (a multi-thousand-token system prompt times dozens of calls per unit
   can dominate total cost).
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

## Worked example (illustrative)

A ~28-unit PDF-extraction fleet came out near 14M tokens/month, ~$0.50
per unit/month at Haiku metered rates. Biggest drivers were monolithic
packets and item-heavy sources re-sending the system prompt per item —
i.e. the prompt-caching lever in step 7. Re-measure with the recipe;
don't carry a stale number.
