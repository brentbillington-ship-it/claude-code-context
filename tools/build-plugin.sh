#!/usr/bin/env bash
# Assemble the ccc plugin from canonical sources. See plugin/README.md.
# The assembled payload dirs are git-ignored; only the manifest, hooks.json,
# and README are committed.

set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cd "$root"

rm -rf plugin/skills plugin/agents plugin/hooks/scripts
mkdir -p plugin/skills plugin/agents plugin/hooks/scripts

# Skills: every canonical skill directory.
for d in skills/*/; do
  cp -r "$d" "plugin/skills/$(basename "$d")"
done

# Agents: cross-project core library + the universal quality gate.
cp playbook/agents/*.md plugin/agents/
cp agents/senior-product-review.md plugin/agents/

# Hook scripts (git-prepare-commit-msg is a git hook, not a Claude hook; skipped).
for f in playbook/templates/hooks/*.sh; do
  case "$f" in
    *git-prepare-commit-msg.sh) continue ;;
  esac
  cp "$f" plugin/hooks/scripts/
done
chmod +x plugin/hooks/scripts/*.sh

# The skill-router's rules file rides along with its script.
cp playbook/templates/hooks/skill-rules.json plugin/hooks/scripts/

# Sanity: every script hooks.json references must exist.
missing=0
while IFS= read -r s; do
  rel="${s/\$\{CLAUDE_PLUGIN_ROOT\}\//plugin/}"
  [[ -f "$rel" ]] || { echo "MISSING: $rel (referenced by hooks.json)"; missing=1; }
done < <(grep -oE '\$\{CLAUDE_PLUGIN_ROOT\}/[^"]+\.sh' plugin/hooks/hooks.json)
[[ $missing -eq 0 ]] || exit 1

echo "plugin assembled: $(ls plugin/skills | wc -l) skills, $(ls plugin/agents/*.md | wc -l) agents, $(ls plugin/hooks/scripts/*.sh | wc -l) hook scripts"
