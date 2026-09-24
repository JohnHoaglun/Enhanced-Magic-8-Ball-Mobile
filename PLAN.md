# Plan

Phases for the Enhanced Magic 8 Ball.

## Phase 1 — Project bootstrap (done 2026-09-23)

- [x] Xcode project with app, unit-test, and UI-test targets (iOS 27.0)
- [x] Git remote configured; `dev` branch created and pushed

## Phase 2 — v1 feature delivery (in progress)

- [x] Domain layer: category weights, saying catalog, deck state, draw engine
- [x] UI: ball, triangular answer window, rock animation, shake/ask-again flow
- [x] Reduce Motion support
- [x] Custom app icon
- [x] Unit tests (Swift Testing) + UI test (shake → reveal → ask again)
- [x] Bootstrap docs, `scripts/verify.sh`, `opencode.json`
- [x] Verification: build, 11/11 unit, 2/2 UI, Info.plist check
- [ ] Delivery commit to `dev` + push

## Phase 3 — Follow-ups (unscheduled)

Only if requested by the user:

- Question input or answer history (excluded by spec v1)
- Haptics or sound (excluded by spec v1)
- Physical-device verification (simulator checks do not prove device behavior)
