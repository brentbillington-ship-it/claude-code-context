#!/usr/bin/env bash
# SubagentStop hook — implements the queue-handoff pattern for sequential subagent orchestration.
# When a subagent finishes, this hook pops the next task from .claude/queue.txt
# and emits a message instructing the parent to "Use the X subagent on Y".
# Attach via settings.json:
#   "SubagentStop": [{ "hooks": [{"type": "command", "command": "path/to/subagent-stop-queue-next.sh"}] }]
# Queue file format (one per line): AGENT_NAME|TASK_DESCRIPTION
# Example: research-subagent|Survey the Texas municipal bond market for 2026 Q1

set -u
QUEUE=".claude/queue.txt"
[ -f "$QUEUE" ] || exit 0

# Pop the first non-empty line.
next=""
while IFS= read -r line || [ -n "$line" ]; do
  [ -z "$line" ] && continue
  [[ "$line" =~ ^# ]] && continue
  next="$line"
  break
done < "$QUEUE"

[ -z "$next" ] && exit 0

# Remove the first non-empty non-comment line.
tmp="$(mktemp)"
seen=0
while IFS= read -r line || [ -n "$line" ]; do
  if [ $seen -eq 0 ] && [ -n "$line" ] && [[ ! "$line" =~ ^# ]]; then
    seen=1
    continue
  fi
  echo "$line" >> "$tmp"
done < "$QUEUE"
mv "$tmp" "$QUEUE"

agent="${next%%|*}"
task="${next#*|}"

# Emit a JSON decision that injects the next instruction into the parent context.
# See hooks reference for hookSpecificOutput schema.
cat <<EOF
{"hookSpecificOutput":{"additionalContext":"Queue-pumped next task. Use the ${agent} subagent on: ${task}"}}
EOF
exit 0
