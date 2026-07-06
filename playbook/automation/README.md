# Automation — session retro + skill tuner

Salvaged from CC-Content 2026-07-06 (that repo's only machinery canonical
CCC lacked). Both are opt-in: nothing here runs until wired up.

## session_retro.py — Stop-hook retrospective

Fires when a Claude Code session ends. Scans the session JSONL for
frustration signals, repeated corrections, and wrong-path redirections,
then writes `retro_report.md` (proposed CLAUDE.md additions — review
before adopting, never auto-apply) and appends a trend line to
`retro_log.md`.

Wire via settings.json:

```json
"Stop": [{ "hooks": [{ "type": "command", "command": "py $CCC/playbook/automation/session_retro.py" }] }]
```

## skill_tuner.py — nightly eval/mutate loop

Auto-Research-style self-improvement: for each skill with a companion
`evals/<skill>-eval.json`, runs the test inputs through Haiku, scores
against the binary assertions, mutates the skill prompt if the pass rate
is below threshold, keeps the better version. Backs up originals to
`_tuner_backup/` before any mutation; trends in `tune_log.md`.

- Handles both `skills/<name>/SKILL.md` (official layout) and legacy flat
  files.
- `ANTHROPIC_API_KEY` env var or keyring — this bills METERED API, not the
  Max subscription (see `playbook/BILLING_BACKEND_PATTERN.md`). ~$0.06/night
  at two skills on Haiku.
- Run: `py playbook/automation/skill_tuner.py [skill] [--dry-run]`.
  Schedule via Windows Task Scheduler for nightly.
- A mutated skill is still a rules edit: review the diff before committing,
  per the action gate.

## evals/

Binary eval sets, one JSON per skill: 2–4 test inputs (happy path + edge
cases), 4–6 yes/no assertions about output quality. Currently:
`scraper-eval.json`, `excel-ops-eval.json` (the excel-ops skill lives in
project repos; the eval is kept as a template).

Generated files (`retro_report.md`, `retro_log.md`, `tune_log.md`,
`_tuner_backup/`) are git-ignored.
