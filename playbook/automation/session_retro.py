#!/usr/bin/env python3
"""
session_retro.py  –  Claude Code Stop-hook retrospective
=========================================================
Fires automatically when a CC session ends (via Stop hook).
Reads the current session's JSONL log, scans for frustration signals,
repeated corrections, and wrong-path redirections, then:
  1. Writes retro_report.md with proposed CLAUDE.md additions
  2. Appends a one-liner to retro_log.md for trend tracking

Config
------
Set RETRO_PROJECT_ROOT env var or it defaults to the script's own
directory (playbook/automation/ in claude-code-context).
"""

import json
import os
import re
import sys
import glob
from datetime import datetime, timezone
from pathlib import Path
from collections import Counter

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = Path(os.environ.get(
    "RETRO_PROJECT_ROOT",
    SCRIPT_DIR  # playbook/automation/ — reports land next to the script
))

# Where CC stores session logs  (Windows path under USERPROFILE)
CC_LOG_DIR = Path.home() / ".claude" / "projects"

# Frustration regex – mirrors what Anthropic ships in Claude Code internally
FRUSTRATION_RE = re.compile(
    r"\b("
    r"wtf|what the (hell|fuck|heck)|"
    r"god ?damn|damn ?it|"
    r"this is (broken|wrong|terrible|awful|garbage|trash)|"
    r"you (broke|ruined|messed|screwed)|"
    r"stop|no[,!.]+ that'?s (not|wrong)|"
    r"i (already|just) (said|told|asked)|"
    r"again\??!|seriously\?|come on|"
    r"ugh|argh|ffs|smh|jfc"
    r")\b",
    re.IGNORECASE,
)

# Correction / redirection patterns
CORRECTION_RE = re.compile(
    r"\b("
    r"no[,.]+ (i said|i meant|i want|that's not)|"
    r"that'?s (wrong|incorrect|not what)|"
    r"try again|redo (that|this|it)|"
    r"go back|revert|undo|"
    r"i didn'?t (ask|say|mean|want)|"
    r"not what i (asked|meant|wanted)|"
    r"you (missed|forgot|ignored|skipped)"
    r")\b",
    re.IGNORECASE,
)

# Repeated-ask detector: user sends very similar messages
SIMILARITY_THRESHOLD = 0.7  # Jaccard similarity


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def jaccard(a: str, b: str) -> float:
    """Word-level Jaccard similarity between two strings."""
    sa = set(a.lower().split())
    sb = set(b.lower().split())
    if not sa or not sb:
        return 0.0
    return len(sa & sb) / len(sa | sb)


def find_latest_session_log() -> Path | None:
    """
    Find the most recently modified JSONL file under ~/.claude/projects/.
    CC stores one JSONL per session, named by session ID.
    """
    if not CC_LOG_DIR.exists():
        return None
    jsonl_files = sorted(
        CC_LOG_DIR.rglob("*.jsonl"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    return jsonl_files[0] if jsonl_files else None


def parse_session(log_path: Path) -> list[dict]:
    """
    Parse a CC session JSONL file.
    Returns list of message dicts with 'role' and 'content' keys.
    """
    messages = []
    with open(log_path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue
            # CC JSONL schema: each line is an event with type/message fields
            # We care about user and assistant messages
            if isinstance(obj, dict):
                role = obj.get("role") or obj.get("type", "")
                content = ""
                if isinstance(obj.get("content"), str):
                    content = obj["content"]
                elif isinstance(obj.get("content"), list):
                    # Multi-block content (text + tool_use etc.)
                    content = " ".join(
                        block.get("text", "")
                        for block in obj["content"]
                        if isinstance(block, dict) and block.get("type") == "text"
                    )
                elif isinstance(obj.get("message"), dict):
                    msg = obj["message"]
                    role = msg.get("role", role)
                    if isinstance(msg.get("content"), str):
                        content = msg["content"]
                    elif isinstance(msg.get("content"), list):
                        content = " ".join(
                            block.get("text", "")
                            for block in msg["content"]
                            if isinstance(block, dict) and block.get("type") == "text"
                        )
                if content.strip():
                    messages.append({"role": role, "content": content.strip()})
    return messages


def analyze(messages: list[dict]) -> dict:
    """
    Run all detectors across session messages.
    Returns a findings dict.
    """
    user_msgs = [m for m in messages if m["role"] in ("user", "human")]
    total_user = len(user_msgs)

    # --- Frustration hits ---
    frustrations = []
    for i, m in enumerate(user_msgs):
        matches = FRUSTRATION_RE.findall(m["content"])
        if matches:
            # Grab a short excerpt around the match
            excerpt = m["content"][:200].replace("\n", " ")
            frustrations.append({
                "index": i,
                "matches": matches,
                "excerpt": excerpt,
            })

    # --- Correction hits ---
    corrections = []
    for i, m in enumerate(user_msgs):
        matches = CORRECTION_RE.findall(m["content"])
        if matches:
            excerpt = m["content"][:200].replace("\n", " ")
            corrections.append({
                "index": i,
                "matches": matches,
                "excerpt": excerpt,
            })

    # --- Repeated asks (user said ~same thing twice) ---
    repeated = []
    for i in range(1, len(user_msgs)):
        sim = jaccard(user_msgs[i]["content"], user_msgs[i - 1]["content"])
        if sim >= SIMILARITY_THRESHOLD:
            repeated.append({
                "index": i,
                "similarity": round(sim, 2),
                "msg_a": user_msgs[i - 1]["content"][:120].replace("\n", " "),
                "msg_b": user_msgs[i]["content"][:120].replace("\n", " "),
            })
    # Also check non-adjacent messages for the same idea
    for i in range(2, len(user_msgs)):
        for j in range(max(0, i - 5), i - 1):
            sim = jaccard(user_msgs[i]["content"], user_msgs[j]["content"])
            if sim >= SIMILARITY_THRESHOLD:
                already = any(r["index"] == i for r in repeated)
                if not already:
                    repeated.append({
                        "index": i,
                        "similarity": round(sim, 2),
                        "msg_a": user_msgs[j]["content"][:120].replace("\n", " "),
                        "msg_b": user_msgs[i]["content"][:120].replace("\n", " "),
                    })

    # --- Topic extraction (rough: most common nouns in corrections) ---
    correction_words = Counter()
    for c in corrections:
        words = re.findall(r"[a-zA-Z_]{4,}", c["excerpt"])
        correction_words.update(w.lower() for w in words)
    # Remove stop words
    stops = {
        "that", "this", "what", "said", "want", "meant", "wrong",
        "incorrect", "again", "asked", "have", "with", "from",
        "your", "just", "already", "told", "doesn", "didn",
    }
    for s in stops:
        correction_words.pop(s, None)
    top_topics = correction_words.most_common(5)

    # --- Compute sentiment score ---
    # Simple: 100 - (frustration_pct + correction_pct + repeat_pct) * 33
    if total_user == 0:
        score = 100
    else:
        frust_pct = len(frustrations) / total_user
        corr_pct = len(corrections) / total_user
        rep_pct = len(repeated) / total_user
        score = max(0, round(100 - (frust_pct + corr_pct + rep_pct) * 33 * 100))

    return {
        "total_user_messages": total_user,
        "frustrations": frustrations,
        "corrections": corrections,
        "repeated_asks": repeated,
        "top_correction_topics": top_topics,
        "session_score": score,
    }


def generate_report(findings: dict, log_path: Path) -> str:
    """Generate markdown retro report."""
    now = datetime.now().strftime("%Y-%m-%d %H:%M CT")
    lines = [
        f"# Session Retro — {now}",
        f"",
        f"**Source:** `{log_path.name}`",
        f"**User messages:** {findings['total_user_messages']}",
        f"**Session score:** {findings['session_score']}/100",
        f"",
    ]

    # Frustration
    lines.append(f"## Frustration Signals ({len(findings['frustrations'])} hits)")
    if findings["frustrations"]:
        for f in findings["frustrations"]:
            lines.append(f"- **Msg #{f['index']}** — triggers: {f['matches']}")
            lines.append(f"  > {f['excerpt']}")
    else:
        lines.append("None detected.")
    lines.append("")

    # Corrections
    lines.append(f"## Corrections / Redirections ({len(findings['corrections'])} hits)")
    if findings["corrections"]:
        for c in findings["corrections"]:
            lines.append(f"- **Msg #{c['index']}** — triggers: {c['matches']}")
            lines.append(f"  > {c['excerpt']}")
    else:
        lines.append("None detected.")
    lines.append("")

    # Repeated asks
    lines.append(f"## Repeated Asks ({len(findings['repeated_asks'])} hits)")
    if findings["repeated_asks"]:
        for r in findings["repeated_asks"]:
            lines.append(f"- **Msg #{r['index']}** (similarity: {r['similarity']})")
            lines.append(f"  > A: {r['msg_a']}")
            lines.append(f"  > B: {r['msg_b']}")
    else:
        lines.append("None detected.")
    lines.append("")

    # Topics
    if findings["top_correction_topics"]:
        lines.append("## Top Correction Topics")
        for word, count in findings["top_correction_topics"]:
            lines.append(f"- `{word}` ({count}x)")
        lines.append("")

    # Proposed CLAUDE.md additions
    lines.append("## Proposed CLAUDE.md Additions")
    lines.append("")
    if findings["frustrations"] or findings["corrections"] or findings["repeated_asks"]:
        lines.append("Based on this session's friction points, consider adding:")
        lines.append("```markdown")
        if findings["repeated_asks"]:
            lines.append("# Rule: Do not ask clarifying questions on topics already covered.")
            lines.append("# If the user repeats a request, the first attempt missed the mark —")
            lines.append("# re-read the original carefully before responding.")
        if findings["corrections"]:
            topics = [t[0] for t in findings["top_correction_topics"][:3]]
            if topics:
                lines.append(f"# Rule: Pay extra attention to: {', '.join(topics)}")
                lines.append(f"# Multiple corrections were needed in these areas.")
        if findings["frustrations"]:
            lines.append("# Rule: If the user shows frustration, pause and ask what")
            lines.append("# specifically went wrong before continuing with the current approach.")
        lines.append("```")
    else:
        lines.append("Session was clean — no additions needed.")
    lines.append("")

    return "\n".join(lines)


def generate_log_entry(findings: dict, log_path: Path) -> str:
    """One-liner for retro_log.md trend tracking."""
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    return (
        f"| {now} | {log_path.name[:20]} | "
        f"{findings['session_score']}/100 | "
        f"F:{len(findings['frustrations'])} "
        f"C:{len(findings['corrections'])} "
        f"R:{len(findings['repeated_asks'])} | "
        f"{findings['total_user_messages']} msgs |"
    )


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    log_path = find_latest_session_log()
    if not log_path:
        print("[retro] No session logs found in", CC_LOG_DIR)
        return

    print(f"[retro] Analyzing: {log_path}")
    messages = parse_session(log_path)
    if not messages:
        print("[retro] No messages parsed — skipping.")
        return

    findings = analyze(messages)

    # Write retro report
    report = generate_report(findings, log_path)
    report_path = PROJECT_ROOT / "retro_report.md"
    report_path.write_text(report, encoding="utf-8")
    print(f"[retro] Report written to {report_path}")

    # Append to log
    log_entry = generate_log_entry(findings, log_path)
    log_path_out = PROJECT_ROOT / "retro_log.md"
    if not log_path_out.exists():
        header = (
            "# Session Retro Log\n\n"
            "| Date | Session | Score | Signals | Volume |\n"
            "|------|---------|-------|---------|--------|\n"
        )
        log_path_out.write_text(header, encoding="utf-8")
    with open(log_path_out, "a", encoding="utf-8") as f:
        f.write(log_entry + "\n")
    print(f"[retro] Log entry appended to {log_path_out}")
    print(f"[retro] Session score: {findings['session_score']}/100")


if __name__ == "__main__":
    main()
