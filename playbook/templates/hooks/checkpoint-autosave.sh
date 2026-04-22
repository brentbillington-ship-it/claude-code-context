#!/usr/bin/env bash
# Stop hook — writes a resume-ready checkpoint to .claude/checkpoints/ on every turn end.
# Captures: files touched this session, open todos (if TodoWrite state available), and the last user prompt.
# Attach via settings.json:
#   "Stop": [{ "hooks": [{"type": "command", "command": "path/to/checkpoint-autosave.sh"}] }]

set -u
CKPT_DIR=".claude/checkpoints"
mkdir -p "$CKPT_DIR"

ts="$(date -u +%Y%m%dT%H%M%SZ)"
out="$CKPT_DIR/$ts.md"

# Files modified in the git working tree.
{
  echo "# Checkpoint $ts"
  echo
  echo "## Working tree"
  git status --short 2>/dev/null | head -50 || echo "(not a git repo)"
  echo
  echo "## Recent commits"
  git log --oneline -5 2>/dev/null || true
  echo
  echo "## Last user prompt (if passed via stdin)"
  cat - 2>/dev/null | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
    # Stop hook receives a JSON envelope; extract what we can.
    print(d.get("stop_reason",""))
except Exception:
    pass
' 2>/dev/null || true
} > "$out"

# Keep only last 20 checkpoints.
ls -t "$CKPT_DIR"/*.md 2>/dev/null | tail -n +21 | xargs -r rm -f
exit 0
