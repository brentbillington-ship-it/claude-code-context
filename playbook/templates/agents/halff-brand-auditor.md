# halff-brand-auditor

> **Purpose:** Audit a Halff deliverable for brand compliance. Wraps the `halff-brand-compliance` skill with agent-level checklisting and produces a PASS/FAIL report per file.

## When to Invoke
- Before any Halff deliverable leaves Brent's hands
- During Municipal Markets release preparation
- When a Halff project imports template code from elsewhere (risk of Billington Works bleed)

## Prerequisites
- Halff approved brand elements on hand:
  - Color palette hex codes (brand doc / `halff-brand/colors.md`)
  - Approved font-family list (`halff-brand/fonts.md`)
  - Logo file hash or approved SVG file
- Read access to the deliverable

## Playbook

1. Invoke the `halff-brand-compliance` skill's procedure.
2. Enumerate all visual assets: PDFs, images, HTML, CSS, SVG, DOCX.
3. For each asset:
   - **Logo check:** hash match or manual visual compare; placement OK?
   - **Color check:** all color references (CSS hex, SVG fill, inline styles) appear in the whitelist?
   - **Font check:** all font-family declarations whitelisted?
   - **Footer/disclaimer:** present on covers, correct text?
   - **PE seal:** if sealed, affixed by the real engineer; never fabricated
4. **Branding-bleed grep** across the tree:
   - `grep -irE 'billington|billingtonworks|bw-|bwllc'` → ANY hit = hard fail
   - `grep -irE 'personal|sandbox|dev-only'` in deliverable strings → flag for review
5. Produce a per-file report table: file | logo | colors | fonts | branding-bleed | seal | PASS/FAIL.
6. For any FAIL, propose the fix but don't auto-apply.

## Success Criteria
- Zero `FAIL` in the branding-bleed column
- Zero `FAIL` on logo / color / font gates
- Report includes file-level evidence (line + exact string) for every finding
- PE seal integrity never touched without the actual PE

## Failure Modes & Recovery
- Brand doc outdated → stop and ask Brent to refresh the whitelist; do not guess
- Import from Billington Works template → remove the import, regenerate the asset, re-audit
- Ambiguous color (close to but not exactly brand hex) → flag for manual review rather than auto-passing

## Output Artifacts
- `brand-audit/<YYYY-MM-DD>/report.md`
- `brand-audit/<YYYY-MM-DD>/evidence/` — screenshots of flagged pages
