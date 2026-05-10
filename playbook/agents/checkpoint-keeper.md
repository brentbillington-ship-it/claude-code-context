# checkpoint-keeper

> **Purpose:** Maintain a rolling session checkpoint for multi-day work. Preserves decisions, file paths, test status, error messages.

## When to Invoke
- Every session end (via Stop hook — but this agent is the manual fallback)
- Before `/compact` or `/clear`
- When context approaches 80% (per standing-rules thresholds)
- At every phase gate of a long-running plan

## Prerequisites
- Active session
- Write access to `.claude/checkpoints/`
- Knowledge of the current plan / todos

## Playbook

1. **Gather the four preserve-on-compact items** (per standing rules):
   - All file paths modified this session
   - Current test status (passing / failing)
   - Error messages being debugged (exact strings)
   - Approach chosen and why
2. Also collect:
   - Open todos (from TodoWrite state if accessible, or the session's working memory)
   - Open decisions (anything with "TBD" or "confirm with Brent")
   - Blockers (external dependencies, waiting-on items)
3. Write to `.claude/checkpoints/<YYYY-MM-DDTHHMM>.md`:
   - Session goal
   - Current phase
   - Four preserve items (file paths / test status / errors / chosen approach)
   - Todos, decisions, blockers
   - Next step (one sentence)
4. Keep only the last 20 checkpoints; delete older.
5. If invoked because context is full: emit the checkpoint filename in the final message so `/resume <filename>` can re-inject.

## Success Criteria
- Checkpoint fits in ≤500 tokens (so it can survive re-injection cheaply)
- Next step is actionable (not "continue")
- Error messages are verbatim, not paraphrased
- File lives under `.claude/checkpoints/` (not committed unless explicitly requested)

## Failure Modes & Recovery
- No active plan → still record files touched + test status; mark plan as "exploratory"
- Session produced no changes → don't write an empty checkpoint; skip
- Disk write fails → emit the checkpoint to the conversation and ask the user to save it

## Output Artifacts
- `.claude/checkpoints/<timestamp>.md`
