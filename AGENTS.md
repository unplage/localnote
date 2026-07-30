# AGENTS.md

## Project Overview

Zero-build PWA note app. Everything is in `index.html` (~1200 lines of inline HTML/CSS/JS). No npm, no bundler, no transpilation.

## Key Files

- `index.html` — Single-file app: UI (HTML), styles (CSS), logic (JS) all inline. `DBManager` (IndexedDB) and `App` class defined in a `<script>` tag.
- `sw.js` — Service Worker. Network-first for HTML, cache-first for static assets. Dynamically scopes by subpath for GitHub Pages multi-project isolation.
- `manifest.json` — PWA manifest with inline SVG data-URIs for icons.
- `clear.html` — Standalone cache-clearing utility page.
- `android/` — Android WebView wrapper. Built via `android/build.sh` (requires local Android SDK/JDK, not automated in CI).

## Dev Workflow

```bash
python3 -m http.server 8080
# Open http://localhost:8080
```

No build step. No lint/test/typecheck commands exist.

## Architecture Notes

- Data layer: IndexedDB (`SimpleNotesDB` v2) with three object stores: `notes`, `categories`, `settings`.
- Categories have an `order` field for sort; `getAllCategories()` auto-assigns `order` if missing.
- Note content is plain text (strings). Legacy rich-text JSON is handled by `extractText()`/`normalizeContent()` compat helpers.
- Note IDs: `Date.now().toString(36) + '_' + Math.random().toString(36).slice(2, 8)`.
- Auto-save uses a configurable timer (default 3s), triggered on editor `input` events.
- Dark theme toggled via `data-theme="dark"` on `<html>`.
- External dependency: Font Awesome 6.4.0 from CDN (only used for icons).

## Gotchas

- Editing the app means editing `index.html` — there is no separate JS/CSS file to modify.
- The Android build script (`android/build.sh`) has hardcoded absolute paths to a specific developer's SDK install; it won't work as-is elsewhere.
- Service Worker caches aggressively. After changes, use `clear.html` or hard-refresh to see updates.
- The `sw.js` cache name is derived from the subpath (`pwa-cache-<path>-v2`); changing the deployment path changes the cache key.
