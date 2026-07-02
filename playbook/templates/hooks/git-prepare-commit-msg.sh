#!/usr/bin/env bash
# Git prepare-commit-msg hook (NOT a Claude Code hook) — stamps every commit
# message with a Central Time date line, enforcing the standing rule
# "Central Time on every timestamp" mechanically.
#
# Install per repo:   cp this file to .git/hooks/prepare-commit-msg && chmod +x
# Or with a hooks dir: place in the dir named by core.hooksPath as prepare-commit-msg
#
# Skips merge/squash template invocations and messages that already carry a CT stamp.

set -u
msg_file="$1"
source="${2:-}"

case "$source" in
  merge|squash) exit 0 ;;
esac

if grep -q '(CT)' "$msg_file" 2>/dev/null; then
  exit 0
fi

ct_date="$(TZ=America/Chicago date '+%Y-%m-%d %H:%M %Z')"
printf '\nDate: %s (CT)\n' "$ct_date" >> "$msg_file"
exit 0
