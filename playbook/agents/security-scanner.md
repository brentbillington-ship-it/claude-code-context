# security-scanner

> **Purpose:** Pre-push security sweep of a repo. Checks for secrets, dependency vulns, dangerous patterns, and committed credentials.

## When to Invoke
- Before pushing a branch that touched configuration, auth, or env handling
- Before every client-facing deliverable
- After a pull/merge that brought in third-party code
- Quarterly audit pass on any active repo

## Prerequisites
- Clean working tree (commit or stash)
- Network access (to query vuln DBs if needed)
- Read access to full git history

## Playbook

1. **Secrets scan across full history.** Run the `secret-scan-preedit.sh` patterns against every blob in history via `git log -p -- <paths>` or `git rev-list --all | xargs -n1 git show`. Surface any match with commit hash + path.
2. **Env / config audit.** List every `*.env*`, `*.pem`, `*.key`, `credentials.*`, `config.*`. Confirm gitignored. Flag any that are tracked.
3. **Dependency vuln check.** `pip list --outdated`, `npm audit`, `go list -m -u all` (as applicable). Flag CVEs rated High/Critical.
4. **Dangerous pattern sweep.** Grep for: `eval(`, `exec(`, `os.system(`, `shell=True`, `child_process.exec`, `dangerouslySetInnerHTML`, `innerHTML =` (for user-controlled input). Case-by-case review.
5. **Committed personal info sweep.** Brent's Halff email, personal email, phone, home address patterns. None should appear in author metadata on client repos.
6. **Branding bleed check.** For client repos: zero Halff/Billington Works references. For Halff repos: zero Billington Works references.
7. Produce a report: **critical / high / medium / low** findings with remediation per item.

## Success Criteria
- Zero critical findings before push
- Every high finding has an explicit fix or an approved deferral
- Full-history scan run, not just HEAD
- Report stored for audit

## Failure Modes & Recovery
- Historical secret found → rotate the credential IMMEDIATELY; don't rewrite history without a lawyer/client conversation for client repos
- Vuln DB unreachable → flag as "scan incomplete" rather than green-lighting
- False positive flood from binary files → add to skip list deliberately, don't disable the whole pattern

## Output Artifacts
- `security/<YYYY-MM-DD>.md` — full report
- `security/<YYYY-MM-DD>/findings.json` — machine-readable for re-check
