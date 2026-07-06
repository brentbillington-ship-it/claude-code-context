#!/usr/bin/env bash
# UserPromptSubmit hook — the skill-router (diet103 pattern, adopted per the
# 2026-07-02 harness review Wave 2 findings). Matches the incoming prompt
# against skill-rules.json and injects the matching rule reminders as
# context, converting prose standing rules into fired-when-relevant gates.
#
# v1 is inject-only: guardrail entries emit a MUST reminder; nothing blocks
# the prompt. Blocking enforcement belongs on PreToolUse hooks (see
# rm-rf-guard, py-pip-guard), not on the user's own words.
#
# Rules file: skill-rules.json next to this script, or $CCC_SKILL_RULES.
# Attach via settings.json:
#   "UserPromptSubmit": [{ "hooks": [{"type": "command", "command": "path/to/skill-router-userpromptsubmit.sh"}] }]

set -u
payload="$(cat -)"
rules="${CCC_SKILL_RULES:-$(dirname "$0")/skill-rules.json}"
[[ -f "$rules" ]] || exit 0

printf '%s' "$payload" | RULES_FILE="$rules" python3 -c '
import json, os, re, sys

# Windows consoles default to cp1252; rule messages are UTF-8.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

try:
    prompt = (json.load(sys.stdin).get("prompt") or "")
except Exception:
    sys.exit(0)

try:
    with open(os.environ["RULES_FILE"], encoding="utf-8") as f:
        rules = json.load(f).get("rules", [])
except Exception:
    sys.exit(0)

out = []
for r in rules:
    pats = r.get("patterns", [])
    skips = r.get("skip", [])
    if any(re.search(p, prompt, re.I) for p in pats) and not any(
        re.search(s, prompt, re.I) for s in skips
    ):
        tag = "GUARDRAIL" if r.get("type") == "guardrail" else "SKILL"
        name = r.get("name", "?")
        msg = r.get("message", "")
        out.append("[skill-router:" + tag + ":" + name + "] " + msg)

if out:
    print("\n".join(out))
' 2>/dev/null

exit 0
