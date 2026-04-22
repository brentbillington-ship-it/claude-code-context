---
name: halff-brand-compliance
description: Use when producing deliverables under the Halff Associates brand — engineering reports, exhibits, memos, PDF plan sets, Municipal Markets reports. Enforces Halff logo placement, approved color palette, font family, and explicit removal of any Billington Works branding. Do not use for Billington Works client deliverables or personal projects.
when_to_use: The user mentions Halff, Municipal Markets, a Halff client project, a report going out under Halff letterhead, or brand audit.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Halff Brand Compliance Skill

Standing rule: any deliverable marked Halff MUST have zero Billington Works branding. Standing rules § Active Projects calls this out for Municipal Markets specifically.

## What to check

- **Logo:** Halff word-mark on cover page + header. Correct aspect ratio, no stretching. No co-branding with Billington Works on the same page.
- **Colors:** Halff primary + secondary palette only. Reject off-palette accent colors that slipped in from another template.
- **Fonts:** Halff-approved font family (to be confirmed in a brand doc — skill body expects Brent to paste the actual font list into a sibling file `halff-brand/fonts.md`).
- **Disclaimer & stamp block:** PE seal placement if the deliverable is sealed. Never fabricate a seal.
- **File naming:** Halff project-number prefix (Brent to confirm the pattern; the skill should prompt if unsure).

## Procedure

1. Read the document. Enumerate images, confirm logos match the canonical file hash if available.
2. Enumerate all color references (hex codes in HTML/CSS, fill values in SVG, etc.) and compare to the Halff palette whitelist.
3. Enumerate font-family declarations and fail any not on the approved list.
4. Grep for the strings "Billington" and "billingtonworks" case-insensitive. Flag any hit as a hard fail.
5. Produce a checklist report: PASS / FAIL per item, with file + line references.
6. On FAIL items, propose the fix but do not apply it without explicit "go" (per standing rules Prime Directive).

## Non-negotiables

- Zero Billington Works branding on Halff deliverables.
- No PE seal fabrication. Ever.
- Don't auto-fix; report + wait for approval.

## Pairs with

- `scraping-pipeline-boilerplate` when Municipal Markets scrape output feeds into a Halff-branded report
- `simplify` post-edit check after any brand correction pass
