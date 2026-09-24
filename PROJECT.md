# Project — Enhanced Magic 8 Ball

A single-screen iOS app that answers a question with a weighted-random Magic
8 Ball saying after a 1-second rock animation.

## Product

- Spec: `Magic 8 Ball -- Product Spec.md` (source of truth)
- Approved UI concept: `Magic 8 Ball -- Approved Idle UI Concept.png`
- One screen, portrait only, dark only, status bar hidden, no scrolling.
- "Shake the Ball" → ball rocks for 1 second (button shows "Shaking", disabled) →
  a random answer appears in the flat classic-blue triangular answer window →
  "Ask Again" returns to idle.
- 101 built-in sayings across 8 theme packs; category weights are
  affirmative 50% / noncommittal 25% / negative 25%.
- No-repeat decks per category, persisted locally; an exhausted deck reshuffles.
- Reduce Motion: the answer is revealed immediately (no rock animation).
- Offline, silent, no haptics, no permissions, no analytics, no accounts.
- Custom app icon: glossy black 8-ball with a white "8" emblem.

## Current state

- iOS 26.0+, SwiftUI, Swift, no third-party dependencies.
- v1 spec implemented; 11 unit tests + 2 UI tests pass.
- Marketing version 1.0, build 3.
- Branch `dev` on `github.com/JohnHoaglun/Enhanced-Magic-8-Ball-Mobile`.

## Verification

- `scripts/verify.sh` — build + unit tests + UI tests (iOS simulator).
- Last verified: 2026-09-23 — 11/11 unit, 2/2 UI; idle-state preview and app
  icon visually checked against the approved concept.
