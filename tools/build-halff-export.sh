#!/usr/bin/env bash
# Assemble the Halff-facing export of CCC into halff-export/ (git-ignored).
#
# Replaces the hand-scrubbed fork workflow (CC-Content, then the 2026-07-06
# halff-ccc zip): personal/engagement content is dropped, identifying names
# are genericized, and a denylist grep FAILS the build if anything personal
# survives. Canonical stays this repo; the export is a build artifact —
# regenerate after every release, never edit the export by hand.
#
# Usage: bash tools/build-halff-export.sh   (then push halff-export/* to the
# Halff-side repo)

set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cd "$root"
out="halff-export"

rm -rf "$out"
mkdir -p "$out"

# --- 1. Copy tracked files at HEAD -----------------------------------------
git archive HEAD | tar -x -C "$out"

# --- 2. Drop personal / engagement / archive content -----------------------
drop=(
  "AGENTS_BROWSER_BOOTSTRAP.md"
  "AGENTS_COLOR_TRACE.md"
  "AGENTS_DEPLOY_VERIFY.md"
  "AGENTS_VISUAL_QA.md"
  "agents/family-office-tracker"
  "agents/proposal-contract-manager.md"
  "agents/proposal-legal-review.md"
  "agents/proposal-pricing-qa.md"
  "agents/proposal-scope-qa.md"
  "playbook/EXPORT"
  "playbook/agents/client-deliverable-packager.md"
  "playbook/research/family-office-tooling.md"
  "playbook/research/freelancer.md"
  "playbook/sessions"
  "playbook/synthesis/2026-07-02_harness_review.md"
  "playbook/synthesis/2026-07-06_harness_review.md"
  "playbook/templates/claude-md/campaign-tool.CLAUDE.md"
  "playbook/templates/claude-md/client-deliverable.CLAUDE.md"
  "playbook/templates/skills/bw-client-deliverable"
  "playbook/templates/skills/campaign-data-processor"
  # The generator itself: it contains the scrub map + denylist verbatim, so
  # the name-map would rewrite it and silently defang the verify step. The
  # export is a build artifact; the generator lives only in canonical.
  "tools/build-halff-export.sh"
)
for p in "${drop[@]}"; do rm -rf "$out/$p"; done

# --- 3. Structural rewrites (standing rules) --------------------------------
rules="$out/CLAUDE_CODE_STANDING_RULES.md"

python3 - "$rules" <<'PYEOF'
import re, sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()

# Header + identity
text = text.replace(
    "## Brent Billington | Billington Works / Halff Associates",
    "## Brent Billington | Halff Associates — Applied Technology")
text = text.replace(
    "Civil PE at Halff Associates (DFW). Building a freelance AI dev business called **Billington Works**.",
    "Civil PE at Halff Associates (DFW), working on applied technology and automation:\n"
    "Civil 3D standards, AutoLISP tooling, pursuit intelligence, and contract/document\n"
    "automation across the firm's municipal portfolio.")

# Drop the Accounts subsection (personal-repo governance) but keep the
# SSO runbook that follows it.
text = re.sub(
    r"### Accounts — two identities.*?(?=### Halff SAML SSO)",
    "", text, flags=re.S)

# Drop personal rows from Active Projects; keep Halff rows.
text = re.sub(r"^\| Canvassing App \|.*\n", "", text, flags=re.M)
text = re.sub(r"^\| Signs Map \|.*\n", "", text, flags=re.M)

# Agent Library Lookup Order: collapse the personal tiers.
text = text.replace(
    "2. **CCC engagement-specific** — `claude-code-context/agents/<name>.md`\n"
    "   and `claude-code-context/agents/<group>/<name>.md`. Includes\n"
    "   `senior-product-review.md` (universal quality gate) and the\n"
    "   `family-office-tracker/` bundle (gala-holdings engagement).\n"
    "3. **CCC project playbooks** — `AGENTS_*.md` at the CCC root. Currently\n"
    "   four Canvassing-Map-specific operational playbooks (BROWSER_BOOTSTRAP,\n"
    "   COLOR_TRACE, DEPLOY_VERIFY, VISUAL_QA).\n"
    "4. **The active project's own agents**",
    "2. **CCC engagement-specific** — `claude-code-context/agents/<name>.md`.\n"
    "   `senior-product-review.md` (universal quality gate).\n"
    "3. **The active project's own agents**")
text = text.replace(
    "5. **Other Brent-managed repos** under\n"
    "   `C:\\Users\\Brent\\Code\\BillingtonWorks\\*\\agents\\` and\n"
    "   `C:\\Users\\Brent\\Code\\BillingtonWorks\\*\\.claude\\agents\\`. Last resort",
    "4. **Other managed repos** under the local code root. Last resort")

open(path, "w", encoding="utf-8", newline="\n").write(text)
PYEOF

# --- 3b. Registry, README, and cross-link rewrites --------------------------
python3 - "$out" <<'PYEOF'
import os, re, sys
root = sys.argv[1]

def rewrite(rel, fn):
    p = os.path.join(root, rel)
    s = open(p, encoding="utf-8").read()
    s = fn(s)
    open(p, "w", encoding="utf-8", newline="\n").write(s)

# AGENT_MANAGER: two-tier scope, drop personal rows + changelog entries.
def agent_manager(s):
    s = s.replace(
        "> **Scope:** This registry covers all active agents in CCC across three tiers:",
        "> **Scope:** This registry covers all active agents across two tiers:")
    s = re.sub(r"^> 2\. \*\*Engagement-specific\*\*.*\n", "> 2. **Cross-cutting** at `agents/<name>.md` and root `AGENTS_*.md` — the universal `senior-product-review` quality gate and the `AGENTS_RESEARCH_BOOTSTRAP` pre-flight playbook.\n", s, flags=re.M)
    s = re.sub(r"^> 3\. \*\*Project playbooks\*\*.*\n", "", s, flags=re.M)
    s = s.replace("Invoke AGENTS_VISUAL_QA.md — run full visual QA against live site.",
                  "Invoke AGENTS_RESEARCH_BOOTSTRAP.md — pre-flight gate before dispatching research agents.")
    drop = re.compile(r"family-office|proposal-(contract|legal|pricing|scope)|AGENTS_(BROWSER|COLOR|DEPLOY|VISUAL|PLAYWRIGHT)|client-deliverable-packager")
    s = "\n".join(l for l in s.split("\n") if not drop.search(l))
    return s
rewrite("AGENT_MANAGER.md", agent_manager)

# Standing rules: V-section binding list loses the engagement agent.
def rules(s):
    return s.replace(
        "`browser-qa`, `family-office-tracker/AESTHETICS`, and any inline",
        "`browser-qa`, and any inline")
rewrite("CLAUDE_CODE_STANDING_RULES.md", rules)

# README: tree description reflects the trimmed layout.
def readme(s):
    s = re.sub(r"^- \*\*`AGENTS_\*\.md`\*\*.*\n", "- **`AGENTS_RESEARCH_BOOTSTRAP.md`** — pre-flight gate for research sessions (environment matrix, reachability probe, methodology decision tree).\n", s, flags=re.M)
    s = re.sub(r"^- \*\*`agents/`\*\*.*\n", "- **`agents/senior-product-review.md`** — the universal senior-review quality gate (S1-S6).\n", s, flags=re.M)
    return s
rewrite("README.md", readme)

# Mid-sentence references to dropped AGENTS_* playbooks.
def browser_qa(s):
    s = s.replace(
        'When standing rules say "run visual QA" — for Canvassing-Map specifically, the project-specific extension at `AGENTS_VISUAL_QA.md` (CCC root) is the operational playbook; use this generic agent for any other web target',
        'When standing rules say "run visual QA" — use a project-specific QA playbook if one exists; otherwise use this generic agent for any web target')
    s = s.replace(
        '(Canvassing-Map releases use the project-specific extension at `AGENTS_VISUAL_QA.md`)',
        '')
    return s
rewrite("playbook/agents/browser-qa.md", browser_qa)

def deploy_verify(s):
    s = s.replace(" Cross-project version of `AGENTS_DEPLOY_VERIFY.md` (Canvassing-Map specific).", "")
    s = s.replace(" Cross-project — for the Canvassing-Map-specific flow see `AGENTS_DEPLOY_VERIFY.md` at the CCC root.", " Cross-project.")
    return s
rewrite("playbook/agents/deploy-verify.md", deploy_verify)

# Cross-links and pairs-with lines pointing at dropped content: drop the line.
LINE_DROP = re.compile(r"bw-client-deliverable|campaign-data-processor|client-deliverable-packager|family-office|AGENTS_(VISUAL_QA|COLOR_TRACE|DEPLOY_VERIFY|BROWSER_BOOTSTRAP)")
for rel in ("playbook/agents/data-viz-reviewer.md",
            "playbook/agents/leaflet-map-debugger.md",
            "playbook/agents/maps-tooling-reviewer.md",
            "playbook/templates/claude-md/web-app.CLAUDE.md",
            "playbook/templates/skills/apps-script-deployer/SKILL.md",
            "playbook/templates/skills/civil-eng-qto-helper/SKILL.md",
            "playbook/templates/skills/scraping-pipeline-boilerplate/SKILL.md",
            "playbook/synthesis/GAP_ANALYSIS.md",
            "playbook/synthesis/RECOMMENDATIONS.md",
            "playbook/synthesis/PATTERNS.md",
            "playbook/synthesis/ANTI_PATTERNS.md",
            "playbook/agents/browser-qa.md"):
    p = os.path.join(root, rel)
    if not os.path.exists(p):
        continue
    s = open(p, encoding="utf-8").read()
    kept = []
    for l in s.split("\n"):
        if LINE_DROP.search(l):
            # keep list intact when the token is one item among several
            l2 = re.sub(r"`(bw-client-deliverable|campaign-data-processor)/?`,? ?", "", l)
            l2 = re.sub(r"`client-deliverable-packager` agent, ", "", l2)
            if LINE_DROP.search(l2) or l2.strip(" -*") == "":
                continue
            l = l2
        kept.append(l)
    open(p, "w", encoding="utf-8", newline="\n").write("\n".join(kept))
PYEOF

# --- 4. Name-map scrub across every text file -------------------------------
python3 - "$out" <<'PYEOF'
import os, re, sys

root = sys.argv[1]
# Ordered: longest/most-specific first.
MAP = [
    (r"Gala Holdings Tracker\s*\n?research run", "competitor-research run"),
    (r"the May 5, 2026 Gala Holdings Tracker", "a May 2026 competitor-research"),
    (r"Gala V1 \(2026-05-05\)", "a competitor-research run (2026-05-05)"),
    (r"Gala V2 run", "prior visual-research run"),
    (r"Gala research V2", "competitor-research V2"),
    (r"the original Gala CCP", "the original research CCP"),
    (r"gala-holdings(-tracker)?( engagement)?", "a prior engagement"),
    (r"Gala( Holdings)?", "a prior engagement"),
    (r"an invented Vyzer pricing tier", "an invented vendor pricing tier"),
    (r"The Vyzer failure", "The original failure"),
    (r"Vyzer(-incident)?", "vendor-pricing incident"),
    (r"BB-Notes v?[0-9.]+ \(CodeMirror", "a web-app v4.3 (CodeMirror"),
    (r"the May 7, 2026 BB-Notes v2 ship", "a May 2026 web-app v2 ship"),
    (r"\(BB-Notes (2026-[0-9-]+)", r"(prior web-app, \1"),
    (r"BB-Notes \(2026-05-07\)", "A prior web-app build (2026-05-07)"),
    (r"BB-Notes('s?)? (E[0-9.]+ )?", "the prior web-app "),
    (r"BB-Notes", "the prior web-app"),
    (r"Canvassing-Map CLAUDE\.md Rule 1 documents this symptom",
     "A project's own CLAUDE.md should document this symptom where it recurs"),
    (r"\(Canvassing-Map, Signs Map, other web apps\)",
     "(any web app using an `APP_VERSION` string)"),
    (r"Canvassing[- ]Map( releases use the project-specific extension at `AGENTS_VISUAL_QA\.md`)?", "the mapping app"),
    (r"Canvassing App", "the mapping app"),
    (r"Canvassing turf cutting", "Territory / turf cutting"),
    (r"Canvassing", "mapping-app"),
    (r"Signs[- ]Map", "the signs app"),
    (r"Signs Map", "the signs app"),
    (r"\(Coppell does, via the sign-map repo's\s*\n?\s*`parcels\.js`\), that", ", that"),
    (r"sign-map repo", "map repo"),
    (r"brentbillington-ship-it/claude-code-context", "the canonical CCC repo"),
    (r"brentbillington-ship-it/[A-Za-z-]+", "a personal repo"),
    (r"brentbillington-ship-it", "the personal account"),
    (r"Billington Works client", "client"),
    (r"zero Billington Works branding", "zero external branding"),
    (r"Billington[- ]Works[- ]Site", "an external site"),
    (r"Billington Works \(BW\)|Billington Works|BillingtonWorks", "an external business"),
    (r"Halff↔BW", "Halff/external"),
    (r"\bBW\b", "external"),
    (r"leaves Brent's hands", "leaves the author's hands"),
    (r"Brent stops shipping Apps Script", "Apps Script work tapers off"),
    (r"Brent stops doing civil-eng AutoLISP work", "Civil-eng AutoLISP work tapers off"),
    (r"Brent stops Halff work", "Halff brand work tapers off"),
    (r"Halff Municipal-Markets pipeline retired", "Scraping pipelines retired"),
    (r"C:\\\\Users\\\\Brent\\\\Code\\\\BillingtonWorks[^ `\n]*", "the local code root"),
    (r"CC-Content", "the prior Halff-side rules repo"),
    # cleanup: article doubling introduced by phrase substitutions
    (r"\bthe the\b", "the"),
    (r"\ba an\b", "an"),
    (r"\ba a\b", "a"),
]

SKIP_EXT = {".png", ".ico", ".zip", ".pyc"}

for dirpath, dirnames, filenames in os.walk(root):
    for fn in filenames:
        p = os.path.join(dirpath, fn)
        if os.path.splitext(fn)[1].lower() in SKIP_EXT:
            continue
        try:
            s = open(p, encoding="utf-8").read()
        except (UnicodeDecodeError, PermissionError):
            continue
        orig = s
        for pat, rep in MAP:
            s = re.sub(pat, rep, s)
        if s != orig:
            open(p, "w", encoding="utf-8", newline="\n").write(s)
PYEOF

# --- 5. Repo-identity touch-ups ---------------------------------------------
python3 - "$out" <<'PYEOF'
import json, sys, os
root = sys.argv[1]

pj = os.path.join(root, "plugin", ".claude-plugin", "plugin.json")
d = json.load(open(pj, encoding="utf-8"))
d["description"] = d["description"].replace(
    "Brent Billington's Claude Code operating system",
    "Halff applied-technology Claude Code harness")
d["author"] = {"name": "Halff Applied Technology"}
json.dump(d, open(pj, "w", encoding="utf-8", newline="\n"), indent=2)

rd = os.path.join(root, "README.md")
s = open(rd, encoding="utf-8").read()
s = s.replace("# claude-code-context", "# claude-code-context (Halff)", 1)
s = s.replace(
    "Brent's operating system for every Claude Code session across every project.",
    "an operating system for Claude Code sessions across Halff applied-technology projects.")
open(rd, "w", encoding="utf-8", newline="\n").write(s)
PYEOF

# --- 6. Denylist verify — the build FAILS if anything personal survives -----
denylist='Billington Works|BillingtonWorks|BB-Notes|Vyzer|brentbillington-ship-it|family-office|bw-client|campaign-data|choochoo|CC-Content|Canvassing|Signs Map|AGENTS_VISUAL_QA|AGENTS_COLOR_TRACE|AGENTS_DEPLOY_VERIFY|AGENTS_BROWSER_BOOTSTRAP|the the '
hits=$(grep -rInE "$denylist" "$out" --binary-files=without-match || true)
if [[ -n "$hits" ]]; then
  echo "EXPORT FAILED — personal references survived the scrub:"
  echo "$hits"
  exit 1
fi

echo "halff-export assembled: $(find "$out" -type f | wc -l) files, denylist clean"
