#!/usr/bin/env bash
# PreToolUse hook — runs Ruff against Python files on Write/Edit/MultiEdit.
# Informational only (|| true). Matches the rule already documented in CLAUDE_CODE_STANDING_RULES.md.
# Attach via settings.json:
#   "PreToolUse": [{ "matcher": "Write|Edit|MultiEdit", "hooks": [{"type": "command", "command": "path/to/ruff-pretooluse.sh"}] }]
#
# stdin is the tool-use JSON; we read it once and extract the target path.

set -u

payload="$(cat -)"
file_path="$(printf '%s' "$payload" | python3 -c 'import json,sys;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("file_path",""))' 2>/dev/null || true)"

case "${file_path,,}" in
  *.py|*.pyw) ;;
  *) exit 0 ;;
esac

command -v ruff >/dev/null 2>&1 || exit 0

ruff check --stdin-filename "$file_path" <<<"$(printf '%s' "$payload" | python3 -c 'import json,sys;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("content",""))')" || true
exit 0
