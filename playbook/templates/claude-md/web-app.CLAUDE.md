# CLAUDE.md — Web App

## Build / Run (put critical ops at the very top)

```
npm install
npm run dev           # local dev server with HMR
npm run build         # production bundle
npm run lint && npm run test
```

Deploy: GitHub Pages via `main` branch; bump `version.js` and all `?v=` query strings in `index.html` on every release.

---

## Prime rules — first 5 lines get the most attention

1. MUST use named exports. No default exports.
2. MUST bump `version.js` and `?v=` query strings on every release.
3. MUST use Playwright for any browser automation. Selenium is banned.
4. Review the actual file before theorizing. Never guess API shapes.
5. One task per session. `/clear` between unrelated work.

---

## Stack

- Frontend: vanilla JS + Leaflet.js (for map projects) OR React 18 (for SPA projects) — confirm per project
- Styling: CSS custom properties; design tokens in `tokens.css`
- State: URL params for shareable state; `localStorage` for per-user prefs
- Data: Google Sheets via Apps Script for simple cases; real backend otherwise

## File layout

```
src/
├── index.html
├── main.js
├── styles.css
├── components/
├── lib/
└── version.js
tests/
.claude/
├── settings.json
└── skills/
```

## Testing

- `npm test` runs unit tests
- Playwright E2E in `tests/e2e/`; `wait_until: "networkidle"` always, explicit 30s timeout, screenshot on failure
- Visual QA via `AGENTS_VISUAL_QA.md` agent

## Conventions

- Commit messages: imperative mood, scope prefix (`feat(map): …`, `fix(sheets): …`)
- Branches: `feature/<short-name>` off main
- PRs: draft first, mark ready after tests pass
- No `console.log` left in committed code; use a `debug.js` helper gated on `?debug=1`

## What NOT to do

- Don't add frameworks speculatively (Vue/Svelte/Next) without explicit go
- Don't add state-management libraries for simple apps — URL + localStorage first
- Don't import a UI kit if tokens + plain CSS will do
- Don't `force push`; never on main
- Don't disable lint/test in CI

## Last 5 lines — read again before committing

- `version.js` bumped?
- `?v=` query strings updated?
- Tests pass locally?
- Linter clean?
- Screenshot captured for any visible change?
