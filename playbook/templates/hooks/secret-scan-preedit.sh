#!/usr/bin/env bash
# PreToolUse hook — scans Write/Edit content for common secret patterns before the file is written.
# Exit 2 = block. Use on every client repo.
# Attach via settings.json:
#   "PreToolUse": [{ "matcher": "Write|Edit|MultiEdit", "hooks": [{"type": "command", "command": "path/to/secret-scan-preedit.sh"}] }]

set -u
payload="$(cat -)"

content="$(printf '%s' "$payload" | python3 -c '
import json,sys
d=json.load(sys.stdin)
ti=d.get("tool_input") or {}
# Covers Write (content), Edit/MultiEdit (new_string, edits[].new_string)
chunks=[]
if "content" in ti: chunks.append(ti["content"])
if "new_string" in ti: chunks.append(ti["new_string"])
for e in (ti.get("edits") or []):
    if "new_string" in e: chunks.append(e["new_string"])
print("\n".join(c for c in chunks if isinstance(c,str)))
' 2>/dev/null || echo "")"

# Patterns sourced from detect-secrets + gitleaks common rules. Paraphrased, not copied.
deny_patterns=(
  'ghp_[A-Za-z0-9]{36,}'                     # GitHub PAT classic
  'github_pat_[A-Za-z0-9_]{60,}'             # GitHub fine-grained
  'sk-ant-[A-Za-z0-9\-_]{80,}'               # Anthropic
  'sk-[A-Za-z0-9]{40,}'                      # OpenAI classic
  'sk-proj-[A-Za-z0-9\-_]{40,}'              # OpenAI project
  'AKIA[0-9A-Z]{16}'                         # AWS access key
  'AIza[0-9A-Za-z_\-]{35}'                   # Google API key
  'xox[baprs]-[A-Za-z0-9-]{10,}'             # Slack token
  '-----BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY-----'
  'glpat-[A-Za-z0-9_\-]{20,}'                # GitLab PAT
  'ya29\.[A-Za-z0-9_\-]{40,}'                # Google OAuth
)

for pat in "${deny_patterns[@]}"; do
  if printf '%s' "$content" | grep -E -q "$pat"; then
    >&2 echo "BLOCKED by secret-scan: matched /$pat/. If this is a test fixture, place it in a .gitignored file."
    exit 2
  fi
done

exit 0
