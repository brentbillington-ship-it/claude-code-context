#!/usr/bin/env bash
# PreToolUse Bash guard — blocks dangerous shell commands before they execute.
# Born from the Dec-2025 rm -rf ~/ expansion incident (GH #10077).
# Attach via settings.json:
#   "PreToolUse": [{ "matcher": "Bash", "hooks": [{"type": "command", "command": "path/to/rm-rf-guard.sh"}] }]
# Exit 2 = block. Exit 0 = allow. See https://code.claude.com/docs/en/hooks.

set -u
payload="$(cat -)"
cmd="$(printf '%s' "$payload" | python3 -c 'import json,sys;d=json.load(sys.stdin);print((d.get("tool_input") or {}).get("command",""))' 2>/dev/null || echo "")"

# Normalize whitespace; lowercase for matching.
lc="$(printf '%s' "$cmd" | tr -s ' ' ' ' | tr '[:upper:]' '[:lower:]')"

deny_patterns=(
  'rm[[:space:]]+-[rRfF]+[[:space:]]+(/|~|\*|\.\./)'
  'rm[[:space:]]+-[rRfF]+[[:space:]]+\$home'
  'git[[:space:]]+push[[:space:]]+--force'
  'git[[:space:]]+push[[:space:]]+-f([[:space:]]|$)'
  'git[[:space:]]+reset[[:space:]]+--hard[[:space:]]+origin'
  'chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/'
  ':\(\)\{.*:\|:&.*\};:'            # fork bomb
  '>[[:space:]]*/dev/(sd|nvme|hd)'   # direct-to-disk redirection
  'dd[[:space:]]+if=.+of=/dev/(sd|nvme|hd)'
  'mkfs\.'
)

for pat in "${deny_patterns[@]}"; do
  if [[ "$lc" =~ $pat ]]; then
    >&2 echo "BLOCKED by rm-rf-guard: matched /$pat/ in command: $cmd"
    exit 2
  fi
done

exit 0
