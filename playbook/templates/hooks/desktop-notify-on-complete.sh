#!/usr/bin/env bash
# Stop hook — desktop notification when a work order completes cleanly.
# Attach via settings.json Stop event. Safe to pair with checkpoint-autosave.sh (hooks array).
set -u
msg="Claude Code run complete"
case "$(uname -s)" in
  Linux*)   command -v notify-send >/dev/null && notify-send "Claude Code" "$msg" || true ;;
  Darwin*)  osascript -e "display notification \"$msg\" with title \"Claude Code\"" 2>/dev/null || true ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -NoProfile -Command \
      "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$msg','Claude Code')" 2>/dev/null || true ;;
esac
exit 0
