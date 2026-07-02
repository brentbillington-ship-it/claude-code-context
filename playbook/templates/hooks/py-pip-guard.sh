#!/usr/bin/env bash
# PreToolUse Bash guard — enforces the standing rule "py not python, py -m pip not pip"
# mechanically instead of by prose. Windows-only rule: on machines without the
# py launcher (Linux containers, macOS), this hook exits 0 silently.
# Attach via settings.json:
#   "PreToolUse": [{ "matcher": "Bash", "hooks": [{"type": "command", "command": "path/to/py-pip-guard.sh"}] }]
# Exit 2 = block. Exit 0 = allow.

set -u

# Only enforce where the py launcher exists (i.e., Brent's Windows machines).
command -v py >/dev/null 2>&1 || exit 0

payload="$(cat -)"
cmd="$(printf '%s' "$payload" | python3 -c 'import json,sys;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("command",""))' 2>/dev/null || echo "")"

# Match bare python/pip at a command position (start of line, or after && ; |).
if printf '%s' "$cmd" | grep -Eq '(^|&&|;|\|)[[:space:]]*(python3?|pip3?)[[:space:]]'; then
  >&2 echo "BLOCKED by py-pip-guard: use 'py' not 'python', 'py -m pip' not 'pip' (standing rules, Python Stack). Command was: $cmd"
  exit 2
fi

exit 0
