#!/usr/bin/env bash
# SessionStart hook — injects environment awareness + standing-rules pointers
# at the top of every session, killing the "read only the top of the rules
# file" failure mode mechanically.
# Attach via settings.json:
#   "SessionStart": [{ "hooks": [{"type": "command", "command": "path/to/session-start-context.sh"}] }]
# Output: JSON on stdout; additionalContext is injected into the session.

set -u

# Detect which environment this session is in (see standing rules § Sandbox / Network).
if [[ -n "${CLAUDE_CODE_PROXY_RESOLVES_HOSTS:-}" ]]; then
  env_name="claude.ai/code container (proxied network; most external hosts blocked at network layer; widen allowlist + RESTART, or use WebFetch/WebSearch; use pre-installed Chromium, never playwright install)"
else
  env_name="local CLI (sandbox allowlist widenable via .claude/settings.local.json + restart; ThinkPad browser rules apply)"
fi

branch="$(git branch --show-current 2>/dev/null || echo 'no-git')"
ct_now="$(TZ=America/Chicago date '+%Y-%m-%d %H:%M %Z')"

context="CCC session bootstrap (${ct_now}): environment = ${env_name}. Git branch: ${branch}. Standing rules apply in FULL, including the mid-file sections sessions historically skip: Sandbox / Network (Environment Matrix), Research Methodology R1-R6, Debugging Discipline D1-D8, Senior Review S1-S6, Visual Review V1-V5, Shipping Lessons L1-L6. Action gate: numbered plan, stop, wait for 'go'. py not python. Central Time timestamps."

python3 - "$context" <<'EOF'
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": sys.argv[1]}}))
EOF
exit 0
