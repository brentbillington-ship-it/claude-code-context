# Web-app field notes — hard-won specifics worth re-finding

*Promoted from BB-Notes `UPDATE_TO_CCC.md` (2026-07-01/02 build sessions).
Process-level lessons went into `CLAUDE_CODE_STANDING_RULES.md` (D9–D11 +
the GitHub scheduled-workflows note); these are the tech-specific ones.*

## 1. `[hidden]` loses to any author `display` rule

An element with the `hidden` attribute still renders if any CSS rule sets
`display: flex/grid/block` on it — the UA's `[hidden] { display: none }` is
zero-specificity-adjacent and loses. Bit BB-Notes twice in one release (app
shell rendering behind the auth gate; a hidden header ghosting a ~95px gap
on mobile). Fix pattern, once per app:

```css
[hidden] { display: none !important; }
```

## 2. CodeMirror 6: block decorations may not come from ViewPlugins

`Decoration.replace({ block: true })` (tables/embeds/image widgets) throws
`"Block decorations may not be specified via plugins"` at runtime — they
must be provided by a `StateField`:

```js
const field = StateField.define({
  create: buildBlockDecos,
  update: (deco, tr) => (tr.docChanged || tr.selection) ? buildBlockDecos(tr.state) : deco,
  provide: (f) => EditorView.decorations.from(f),
});
```

Inline marks and line decorations stay in the ViewPlugin. The error
surfaces at runtime, not build time.

## 3. GitHub-Contents-backed apps get full-text search for free

If the app already fetches file bodies to parse headers/metadata, retaining
the text gives body search + backlinks for **zero additional API calls** —
no index library needed under ~1MB corpus. Applies to any GitHub-backed
dashboard doing a tree walk at boot.
