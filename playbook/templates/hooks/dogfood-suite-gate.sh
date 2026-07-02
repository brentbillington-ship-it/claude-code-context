#!/usr/bin/env bash
# Stop hook — gives standing rules D6 teeth: "a suite that isn't green on
# main is not a regression set." If the project defines a dogfood command,
# run it when Claude declares a turn done; on failure, block the stop so
# Claude sees the output and keeps working.
#
# Opt-in per project: put the suite command in .claude/dogfood.cmd
# (single line, e.g. "node tests/dogfood/run-all.mjs"). No file = no-op.
# Attach via settings.json:
#   "Stop": [{ "hooks": [{"type": "command", "command": "path/to/dogfood-suite-gate.sh", "timeout": 300}] }]
#
# Guard against loops: if the transcript already shows this hook blocked
# once this turn, we let the stop through (stop_hook_active flag).

set -u
payload="$(cat -)"

active="$(printf '%s' "$payload" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("stop_hook_active", False))' 2>/dev/null || echo False)"
[[ "$active" == "True" ]] && exit 0

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cmd_file="$root/.claude/dogfood.cmd"
[[ -f "$cmd_file" ]] || exit 0

cmd="$(head -1 "$cmd_file")"
[[ -z "$cmd" ]] && exit 0

out="$(cd "$root" && bash -c "$cmd" 2>&1)"
status=$?

if [[ $status -ne 0 ]]; then
  reason="Dogfood suite failed (D6: not green means not done). Command: $cmd. Last output: $(printf '%s' "$out" | tail -20)"
  python3 - "$reason" <<'EOF'
import json, sys
print(json.dumps({"decision": "block", "reason": sys.argv[1]}))
EOF
fi
exit 0
