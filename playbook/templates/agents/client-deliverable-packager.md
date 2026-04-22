# client-deliverable-packager

> **Purpose:** Package the final Billington Works client deliverable. Validates every gate from the `bw-client-deliverable` skill and produces the zip.

## When to Invoke
- End of a Billington Works engagement
- Before sending a deliverable email / upload
- When the user says "ship to client" or "package deliverable"

## Prerequisites
- The engagement's `bw-client-deliverable` skill is present
- `HANDOFF.md` drafted (the skill generates it; this agent validates)
- README.md generated
- Git working tree clean

## Playbook

1. **Dry run the `bw-client-deliverable` skill.** Confirm all gates pass:
   - Secrets clean across full history
   - Zero Halff branding
   - `.env*`, `*.pem`, `*.key`, `secrets/**` absent from tree
   - `settings.json` denies reads of the above globs
   - HANDOFF.md non-empty, contains failed-approaches section
   - README covers install/run/deploy/contact
   - Test suite passing (if present)
   - License appropriate
2. **Manifest the delivery.** List every file that will be in the zip. Confirm each is "changed in this engagement" (per standing rules: only changed files go in the zip).
3. **Timestamp in Central Time.** `touch -t <YYYYMMDDHHMM> <files>` before zipping.
4. **Zip** with the original filenames preserved. Name: `<client>-<project>-<YYYYMMDD>.zip`.
5. **Attach references:**
   - Link to Billington Works AI Addendum (NOT the PDF itself) in the accompanying email / delivery note
   - Link to a case-study-draft doc (internal, not delivered) for Brent's records
6. **Produce a DELIVERY_MANIFEST.md** that lists what's in the zip, what's intentionally NOT in the zip (e.g., `.claude/` if the client requested no AI metadata), and the delivery date.
7. **Do NOT auto-send.** Emit the zip path + manifest; Brent sends it.

## Success Criteria
- All gates pass with documented output
- Zip contains only the changed files
- Filenames + timestamps in Central Time
- Manifest present
- No secret-scan warnings

## Failure Modes & Recovery
- Gate fails on a secret → abort; rotate the credential; repack after cleanup
- Zip size > 100 MB → split or host externally; don't email a giant zip
- Client requested specific exclusions → apply them and document them in the manifest

## Output Artifacts
- `deliverables/<client>-<project>-<YYYYMMDD>.zip`
- `deliverables/<client>-<project>-<YYYYMMDD>.manifest.md`
- `deliverables/DELIVERY_CHECKLIST.md` (gates output)
