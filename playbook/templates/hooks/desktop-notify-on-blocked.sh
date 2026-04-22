#!/usr/bin/env bash
# Notification hook — fires a desktop notification when Claude is blocked (permission prompt, idle, elicitation).
# Attach via settings.json:
#   "Notification": [{ "hooks": [{"type": "command", "command": "path/to/desktop-notify-on-blocked.sh"}] }]
# Matches the Windows/PowerShell pattern documented in CLAUDE_CODE_STANDING_RULES.md.

set -u
msg="Claude Code needs your input"
payload="$(cat - 2>/dev/null || echo '{}')"

# Try to extract a reason for the notification.
reason="$(printf '%s' "$payload" | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
    print(d.get("message") or d.get("reason") or "blocked")
except Exception:
    print("blocked")
' 2>/dev/null || echo "blocked")"

case "$(uname -s)" in
  Linux*)
    command -v notify-send >/dev/null && notify-send "Claude Code" "$msg — $reason" || true
    ;;
  Darwin*)
    osascript -e "display notification \"$msg — $reason\" with title \"Claude Code\"" 2>/dev/null || true
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -NoProfile -Command \
      "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$msg — $reason','Claude Code')" 2>/dev/null || true
    ;;
esac
exit 0
