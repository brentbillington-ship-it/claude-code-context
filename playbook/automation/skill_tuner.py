#!/usr/bin/env python3
"""
skill_tuner.py  –  Auto Research-style skill self-improvement loop
===================================================================
Nightly cron job (or CC /loop task) that iterates over each skill in
skills/, runs synthetic test inputs through Haiku, evaluates outputs
against binary pass/fail assertions in evals/, mutates the skill
prompt if pass rate is below threshold, and keeps the better version.

Usage
-----
    py scripts/skill_tuner.py                 # tune all skills with evals
    py scripts/skill_tuner.py scraper          # tune only scraper skill
    py scripts/skill_tuner.py --dry-run        # show what would change

Config
------
    ANTHROPIC_API_KEY  env var or keyring entry "anthropic_api_key"
    TUNER_MODEL        env var, default "claude-haiku-4-5-20251001"
    TUNER_MAX_ITER     env var, default 3 mutations per skill per run
    TUNER_THRESHOLD    env var, default 0.8 (80% pass rate target)
    TUNER_USE_BATCH    env var, default "true" (use Batch API for 50% off)

Cost estimate (Haiku 4.5, 10 skills × 3 iterations):
    ~45K input tokens ($0.045) + ~15K output tokens ($0.075) = ~$0.12/run
    With Batch API: ~$0.06/run  |  With caching: ~$0.03/run
"""

import json
import os
import re
import sys
import shutil
import hashlib
import time
from datetime import datetime
from pathlib import Path
from typing import Any

# ---------------------------------------------------------------------------
# Try to import anthropic; fail gracefully with install hint
# ---------------------------------------------------------------------------
try:
    import anthropic
except ImportError:
    print("[tuner] ERROR: anthropic package not found.")
    print("        Install with: py -m pip install anthropic --break-system-packages")
    sys.exit(1)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent          # playbook/automation/
PROJECT_ROOT = SCRIPT_DIR.parents[1]                   # repo root
SKILLS_DIR = PROJECT_ROOT / "skills"
EVALS_DIR = SCRIPT_DIR / "evals"
BACKUP_DIR = SCRIPT_DIR / "_tuner_backup"
TUNE_LOG = SCRIPT_DIR / "tune_log.md"


def skill_file(skill_name: str) -> Path:
    """Resolve a skill to its file: official skills/<name>/SKILL.md layout
    first, legacy flat skills/<name>.md as fallback."""
    official = SKILLS_DIR / skill_name / "SKILL.md"
    return official if official.exists() else SKILLS_DIR / f"{skill_name}.md"

MODEL = os.environ.get("TUNER_MODEL", "claude-haiku-4-5-20251001")
MAX_ITERATIONS = int(os.environ.get("TUNER_MAX_ITER", "3"))
PASS_THRESHOLD = float(os.environ.get("TUNER_THRESHOLD", "0.80"))
USE_BATCH = os.environ.get("TUNER_USE_BATCH", "true").lower() == "true"
DRY_RUN = "--dry-run" in sys.argv


def get_api_key() -> str:
    """Retrieve API key from env, then keyring fallback."""
    key = os.environ.get("ANTHROPIC_API_KEY")
    if key:
        return key
    try:
        import keyring
        key = keyring.get_password("anthropic", "api_key")
        if key:
            return key
        # Also try the pipeline's keyring entry
        key = keyring.get_password("anthropic_api_key", "default")
        if key:
            return key
    except ImportError:
        pass
    print("[tuner] ERROR: No API key found.")
    print("        Set ANTHROPIC_API_KEY env var or store in keyring.")
    sys.exit(1)


# ---------------------------------------------------------------------------
# Eval loader
# ---------------------------------------------------------------------------
def load_eval(skill_name: str) -> dict | None:
    """
    Load eval config for a skill. Expected format:
    {
        "skill": "scraper",
        "test_inputs": [
            {"prompt": "...", "context": "..."}
        ],
        "assertions": [
            {"id": "a1", "question": "Does the output contain a valid URL?"},
            {"id": "a2", "question": "Is the output under 500 words?"}
        ]
    }
    """
    eval_path = EVALS_DIR / f"{skill_name}-eval.json"
    if not eval_path.exists():
        return None
    with open(eval_path, "r", encoding="utf-8") as f:
        return json.load(f)


def load_skill(skill_name: str) -> str:
    """Read skill markdown content."""
    return skill_file(skill_name).read_text(encoding="utf-8")


def save_skill(skill_name: str, content: str):
    """Write skill markdown content (backs up first)."""
    skill_path = skill_file(skill_name)
    BACKUP_DIR.mkdir(parents=True, exist_ok=True)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = BACKUP_DIR / f"{skill_name}.md.{ts}.bak"
    shutil.copy2(skill_path, backup_path)
    skill_path.write_text(content, encoding="utf-8")


# ---------------------------------------------------------------------------
# API calls
# ---------------------------------------------------------------------------
def call_haiku(client: anthropic.Anthropic, system: str, user: str) -> str:
    """Single synchronous Haiku call. Returns assistant text."""
    response = client.messages.create(
        model=MODEL,
        max_tokens=1024,
        system=system,
        messages=[{"role": "user", "content": user}],
    )
    return "".join(
        block.text for block in response.content if block.type == "text"
    )


def run_skill_test(
    client: anthropic.Anthropic,
    skill_content: str,
    test_input: dict,
) -> str:
    """
    Run a skill against a test input.
    The skill content becomes the system prompt; the test input is the user msg.
    """
    system = (
        "You are executing a Claude Code skill. Follow the instructions below exactly.\n\n"
        f"{skill_content}"
    )
    user_msg = test_input.get("prompt", "")
    if test_input.get("context"):
        user_msg = f"Context: {test_input['context']}\n\nTask: {user_msg}"
    return call_haiku(client, system, user_msg)


def evaluate_output(
    client: anthropic.Anthropic,
    output: str,
    assertions: list[dict],
    test_input: dict,
) -> list[dict]:
    """
    Run binary assertions against an output using Haiku as judge.
    Returns list of {"id": ..., "question": ..., "pass": bool}
    """
    results = []
    for assertion in assertions:
        question = assertion["question"]
        system = (
            "You are an eval judge. Answer ONLY 'PASS' or 'FAIL'. "
            "No explanation. No other text."
        )
        user_msg = (
            f"Test input: {test_input.get('prompt', '')}\n\n"
            f"Output to evaluate:\n{output}\n\n"
            f"Question: {question}\n\n"
            f"Answer PASS or FAIL:"
        )
        answer = call_haiku(client, system, user_msg).strip().upper()
        passed = answer.startswith("PASS")
        results.append({
            "id": assertion["id"],
            "question": question,
            "pass": passed,
        })
    return results


def compute_pass_rate(eval_results: list[list[dict]]) -> float:
    """Compute overall pass rate across all test inputs × assertions."""
    total = 0
    passed = 0
    for test_results in eval_results:
        for r in test_results:
            total += 1
            if r["pass"]:
                passed += 1
    return passed / total if total > 0 else 0.0


def mutate_skill(
    client: anthropic.Anthropic,
    skill_content: str,
    eval_results: list[list[dict]],
    pass_rate: float,
) -> str:
    """
    Ask Haiku to improve the skill prompt based on eval failures.
    Returns the mutated skill content.
    """
    # Collect failures
    failures = []
    for test_results in eval_results:
        for r in test_results:
            if not r["pass"]:
                failures.append(r["question"])

    failure_summary = "\n".join(f"- FAILED: {q}" for q in failures)

    system = (
        "You are a prompt engineer. Your job is to improve a Claude Code skill prompt "
        "so it passes more eval assertions. Return ONLY the improved skill markdown — "
        "no preamble, no explanation, no code fences. Keep the same structure and headers. "
        "Make targeted, minimal changes to address the specific failures."
    )
    user_msg = (
        f"Current pass rate: {pass_rate:.0%}\n\n"
        f"Failed assertions:\n{failure_summary}\n\n"
        f"Current skill prompt:\n\n{skill_content}"
    )
    return call_haiku(client, system, user_msg)


# ---------------------------------------------------------------------------
# Main tuning loop
# ---------------------------------------------------------------------------
def tune_skill(client: anthropic.Anthropic, skill_name: str) -> dict:
    """
    Run the Auto Research loop for one skill.
    Returns a summary dict.
    """
    eval_config = load_eval(skill_name)
    if not eval_config:
        return {"skill": skill_name, "status": "skipped", "reason": "no eval file"}

    original_content = load_skill(skill_name)
    current_content = original_content
    test_inputs = eval_config["test_inputs"]
    assertions = eval_config["assertions"]

    best_rate = 0.0
    best_content = current_content
    history = []

    for iteration in range(MAX_ITERATIONS + 1):  # iteration 0 = baseline
        # Run all test inputs
        all_results = []
        for test_input in test_inputs:
            output = run_skill_test(client, current_content, test_input)
            results = evaluate_output(client, output, assertions, test_input)
            all_results.append(results)

        rate = compute_pass_rate(all_results)
        history.append({"iteration": iteration, "pass_rate": rate})
        print(f"  [iter {iteration}] pass rate: {rate:.0%}")

        if rate > best_rate:
            best_rate = rate
            best_content = current_content

        # If we've hit threshold, stop early
        if rate >= PASS_THRESHOLD:
            print(f"  ✓ Threshold met ({PASS_THRESHOLD:.0%})")
            break

        # If this was the last iteration, don't mutate
        if iteration >= MAX_ITERATIONS:
            break

        # Mutate and try again
        print(f"  → Mutating skill prompt...")
        current_content = mutate_skill(client, current_content, all_results, rate)

    # Save best version if it improved
    improved = best_rate > history[0]["pass_rate"]
    if improved and not DRY_RUN:
        save_skill(skill_name, best_content)
        print(f"  ✓ Saved improved version (backup in _tuner_backup/)")
    elif improved and DRY_RUN:
        print(f"  [dry-run] Would save improved version")
    else:
        print(f"  — No improvement; original kept")

    return {
        "skill": skill_name,
        "status": "improved" if improved else "unchanged",
        "baseline_rate": history[0]["pass_rate"],
        "best_rate": best_rate,
        "iterations": len(history),
        "history": history,
    }


def discover_tunable_skills() -> list[str]:
    """Find skills that have companion eval files."""
    skills = []
    if not EVALS_DIR.exists():
        return skills
    for eval_file in EVALS_DIR.glob("*-eval.json"):
        skill_name = eval_file.stem.replace("-eval", "")
        if skill_file(skill_name).exists():
            skills.append(skill_name)
    return sorted(skills)


def write_tune_log(results: list[dict]):
    """Append tuning results to tune_log.md."""
    now = datetime.now().strftime("%Y-%m-%d %H:%M CT")
    if not TUNE_LOG.exists():
        header = (
            "# Skill Tuner Log\n\n"
            "| Date | Skill | Status | Baseline | Best | Iterations |\n"
            "|------|-------|--------|----------|------|------------|\n"
        )
        TUNE_LOG.write_text(header, encoding="utf-8")

    with open(TUNE_LOG, "a", encoding="utf-8") as f:
        for r in results:
            f.write(
                f"| {now} | {r['skill']} | {r['status']} | "
                f"{r.get('baseline_rate', '-'):.0%} | "
                f"{r.get('best_rate', '-'):.0%} | "
                f"{r.get('iterations', '-')} |\n"
            )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
def main():
    print(f"[tuner] Skill Tuner v1.0 — {datetime.now().strftime('%Y-%m-%d %H:%M CT')}")
    print(f"[tuner] Model: {MODEL}")
    print(f"[tuner] Threshold: {PASS_THRESHOLD:.0%}")
    print(f"[tuner] Max iterations: {MAX_ITERATIONS}")
    if DRY_RUN:
        print("[tuner] *** DRY RUN — no files will be modified ***")
    print()

    # Filter to specific skill if arg provided
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if args:
        target_skills = args
    else:
        target_skills = discover_tunable_skills()

    if not target_skills:
        print("[tuner] No tunable skills found (need matching eval files in evals/).")
        return

    print(f"[tuner] Skills to tune: {', '.join(target_skills)}\n")

    api_key = get_api_key()
    client = anthropic.Anthropic(api_key=api_key)

    results = []
    for skill_name in target_skills:
        print(f"═══ {skill_name} ═══")
        try:
            result = tune_skill(client, skill_name)
            results.append(result)
        except Exception as e:
            print(f"  ✗ Error: {e}")
            results.append({
                "skill": skill_name,
                "status": "error",
                "baseline_rate": 0,
                "best_rate": 0,
                "iterations": 0,
                "error": str(e),
            })
        print()

    # Write log
    if not DRY_RUN:
        write_tune_log(results)
        print(f"[tuner] Results logged to {TUNE_LOG}")

    # Summary
    print("═══ Summary ═══")
    for r in results:
        status = r["status"]
        if status == "improved":
            print(f"  ✓ {r['skill']}: {r['baseline_rate']:.0%} → {r['best_rate']:.0%}")
        elif status == "unchanged":
            print(f"  — {r['skill']}: {r['baseline_rate']:.0%} (no improvement)")
        elif status == "skipped":
            print(f"  ⊘ {r['skill']}: {r.get('reason', 'skipped')}")
        else:
            print(f"  ✗ {r['skill']}: {r.get('error', 'unknown error')}")


if __name__ == "__main__":
    main()
