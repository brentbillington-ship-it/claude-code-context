#!/usr/bin/env bash
# ccc-doctor — mechanical health check for the CCC harness.
# Every failure class this checks shipped undetected at least once before
# 2026-07-02 (phantom registry rows, dead links, inert hook, committed
# password, rotted line-number references). Run from anywhere inside the
# repo:  bash tools/ccc-doctor.sh
# Exit 0 = healthy, exit 1 = findings (each printed as FAIL/WARN lines).

set -u
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "FAIL not a git repo"; exit 1; }
cd "$root"
fails=0
warns=0

say_fail() { echo "FAIL $*"; fails=$((fails+1)); }
say_warn() { echo "WARN $*"; warns=$((warns+1)); }
say_ok()   { echo "OK   $*"; }

# --- 1. Hook armed -----------------------------------------------------------
hp="$(git config --get core.hooksPath || true)"
if [[ "$hp" != ".githooks" ]]; then
  say_fail "pre-commit guard is INERT: run  git config core.hooksPath .githooks"
elif [[ ! -x .githooks/pre-commit ]]; then
  say_fail ".githooks/pre-commit exists but is not executable: chmod +x it"
else
  say_ok "pre-commit guard armed"
fi

# --- 2. Registry <-> filesystem ---------------------------------------------
# 2a. Every non-RETIRED registry row must point at an existing file.
missing=0
while IFS= read -r p; do
  [[ -z "$p" ]] && continue
  if [[ ! -f "$p" ]]; then say_fail "registry row points at missing file: $p"; missing=1; fi
done < <(grep -E '^\| `[^`]+` \| \*\*(ACTIVE|DORMANT|DRAFT)\*\*' AGENT_MANAGER.md | sed -E 's/^\| `([^`]+)`.*/\1/')
[[ $missing -eq 0 ]] && say_ok "all registry rows resolve to files"

# 2b. Every agent file on disk must have a registry row (any status).
orphans=0
while IFS= read -r f; do
  base="$f"
  if ! grep -qF "\`$base\`" AGENT_MANAGER.md; then
    say_fail "agent file not in AGENT_MANAGER registry: $base"
    orphans=1
  fi
done < <(git ls-files 'AGENTS_*.md' 'agents/**/*.md' 'agents/*.md' 'playbook/agents/*.md')
[[ $orphans -eq 0 ]] && say_ok "no orphan agent files"

# --- 3. Dead relative markdown links ------------------------------------------
deadlinks=0
while IFS=: read -r file link; do
  [[ -z "$link" ]] && continue
  case "$link" in
    http*|\#*|mailto:*) continue ;;
  esac
  target="${link%%#*}"
  [[ -z "$target" ]] && continue
  dir="$(dirname "$file")"
  if [[ ! -e "$dir/$target" && ! -e "$target" ]]; then
    say_fail "dead link in $file -> $link"
    deadlinks=1
  fi
done < <(git ls-files '*.md' | while read -r f; do
  grep -oE '\]\([^)]+\)' "$f" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//' | while read -r l; do echo "$f:$l"; done
done)
[[ $deadlinks -eq 0 ]] && say_ok "no dead relative markdown links"

# --- 4. Line-number references to harness files -------------------------------
ln_hits=0
while IFS= read -r hit; do
  [[ -z "$hit" ]] && continue
  say_warn "line-number reference (use section headings): ${hit:0:120}"
  ln_hits=1
done < <(git grep -nIE '(standing rules|STANDING_RULES\.md)[^|]{0,40}lines? [0-9]+' -- '*.md' \
  | grep -v 'never by line number' | grep -v 'tools/ccc-doctor' || true)
[[ $ln_hits -eq 0 ]] && say_ok "no line-number references to harness files"

# --- 5. Secret scan over the whole tree ---------------------------------------
secret_patterns=(
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{22,}'
  'sk-ant-[A-Za-z0-9_-]{20,}'
  'AKIA[0-9A-Z]{16}'
  'AIza[0-9A-Za-z_-]{35}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
)
sec=0
for pat in "${secret_patterns[@]}"; do
  if git grep -nIE -e "$pat" -- ':!tools/ccc-doctor.sh' ':!playbook/templates/hooks/secret-scan-preedit.sh' ':!.githooks/pre-commit' | grep -q .; then
    say_fail "credential-pattern match: git grep -nE '$pat'"
    sec=1
  fi
done
if [[ -f .githooks/secret-denylist.local ]]; then
  while IFS= read -r lit; do
    [[ -z "$lit" || "$lit" == \#* ]] && continue
    if git grep -nIF -e "$lit" -- ':!.githooks/secret-denylist.local' | grep -q .; then
      say_fail "denylist literal found in tree (see .githooks/secret-denylist.local)"
      sec=1
    fi
  done < .githooks/secret-denylist.local
fi
[[ $sec -eq 0 ]] && say_ok "no credential patterns in tree"

# --- 6. settings.example.json wiring resolves ---------------------------------
wire=0
while IFS= read -r script; do
  rel="${script/\$CCC\//}"
  if [[ ! -f "$rel" ]]; then say_fail "settings.example.json wires missing script: $rel"; wire=1; fi
done < <(grep -oE '\$CCC/[^"]+\.sh' playbook/templates/hooks/settings.example.json 2>/dev/null)
[[ $wire -eq 0 ]] && say_ok "settings.example.json wiring resolves"

# --- 7. Research freshness -----------------------------------------------------
today="$(date +%Y-%m-%d)"
stale=0
for f in playbook/research/*.md; do
  vb="$(grep -oE 'verify-by: [0-9]{4}-[0-9]{2}-[0-9]{2}' "$f" | head -1 | awk '{print $2}')"
  if [[ -z "$vb" ]]; then
    say_warn "no verify-by stamp: $f"
  elif [[ "$vb" < "$today" ]]; then
    say_warn "research past verify-by ($vb): $f"
    stale=1
  fi
done
[[ $stale -eq 0 ]] && say_ok "no research past its verify-by date"

echo
echo "ccc-doctor: $fails FAIL, $warns WARN"
[[ $fails -eq 0 ]] && exit 0 || exit 1
