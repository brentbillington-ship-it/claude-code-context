# ccc plugin (v0.1.0)

CCC packaged as a Claude Code plugin, so projects install the harness instead of fetching raw markdown at session start.

**Status: v0.1, needs a local test on the ThinkPad before daily use.** Built and structure-validated in a web session on 2026-07-02; plugin loading itself could not be exercised there.

## Single source of truth

Only three files are committed here: `.claude-plugin/plugin.json`, `hooks/hooks.json`, and this README. The `skills/`, `agents/`, and `hooks/scripts/` payloads are ASSEMBLED from the canonical locations (`skills/`, `playbook/agents/`, `agents/senior-product-review.md`, `playbook/templates/hooks/`) by:

```bash
bash tools/build-plugin.sh
```

Committing copies would recreate the drift disease this repo just got cured of. Run the build after any change to the canonical files, then reload.

## Try it

```bash
bash tools/build-plugin.sh
claude --plugin-dir ./plugin
# then in the session: /reload-plugins after rebuilds
```

Skills arrive namespaced (`ccc:smallest-honest-change`, `ccc:ccc-doctor`, ...). Hooks wire automatically per `hooks/hooks.json`. The permissions ask/deny block from `playbook/templates/hooks/settings.example.json` is NOT part of the plugin (plugins cannot ship permission rules); copy that block into `~/.claude/settings.json` separately.

## What's inside after a build

- `skills/` — smallest-honest-change, ccc-doctor, ccc-promote, pdf-extract, scraper
- `agents/` — the 14 cross-project core agents + senior-product-review
- `hooks/hooks.json` + `hooks/scripts/` — session-start context, secret scan, ruff, rm-rf guard, py-pip guard, checkpoint autosave, dogfood gate, notify pair, subagent queue
