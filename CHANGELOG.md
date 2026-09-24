# Changelog

User-visible and build-affecting changes. Newest first.

## [1.0 (3)] — 2026-09-23

### Changed
- Deployment target lowered from iOS 27.0 to iOS 26.0 on all three targets
  (app, unit tests, UI tests) so the app installs on iOS 26 devices.
- Build number 2 → 3.

## [1.0 (2)] — 2026-09-23

### Added
- Magic 8 Ball single-screen UI: glossy ball, triangular answer window,
  "Shake the Ball" / "Ask Again" flow.
- 1-second rock animation (skipped under Reduce Motion).
- 101 built-in sayings across 8 theme packs; 50/25/25 weighted category
  selection; no-repeat per-category decks persisted in `UserDefaults`.
- Custom app icon (glossy black 8-ball, white "8" emblem).
- 11 Swift Testing unit tests; XCUITest shake → reveal → ask-again flow.
- Bootstrap docs (`PROJECT.md`, `PLAN.md`, `TODO.md`, `ARCHITECTURE.md`,
  `DECISIONS.md`, `CHANGELOG.md`, `VERSIONS_LOCATIONS.md`),
  `scripts/verify.sh`, `opencode.json`.

### Changed
- Build number 1 → 2.

## [1.0 (1)] — 2026-09-23

### Added
- Xcode project scaffold: app, unit-test, and UI-test targets (iOS 27.0).
- `dev` branch; repo remote configured and pushed.
