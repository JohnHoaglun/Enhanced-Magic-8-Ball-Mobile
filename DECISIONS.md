# Decisions

## D001 — Layered SwiftUI app, no dependencies
Date: 2026-09-23. Every requirement is satisfiable with SwiftUI + Foundation.
No third-party dependencies, no networking, no permissions, no entitlements.

## D002 — Weighted category selection + no-repeat decks
Date: 2026-09-23. A category is chosen by cumulative weight (0.5/0.25/0.25);
within a category, a shuffled index deck is drawn down and persisted so sayings
never repeat until the deck is exhausted, then it reshuffles. Persisting deck
state makes the no-repeat guarantee survive app relaunch.

## D003 — Deterministic test seams
Date: 2026-09-23. A `BallRandomSource` protocol with `SeededRandomSource`
(SplitMix64) plus `InMemoryDeckStateStore` make engine tests deterministic.
Unit tests use the Swift Testing framework per project style.

## D004 — Portrait-only via generated Info.plist
Date: 2026-09-23. `GENERATE_INFOPLIST_FILE = YES`, so orientation is set with
the `INFOPLIST_KEY_UISupportedInterfaceOrientations` build setting
(`UIInterfaceOrientationPortrait`). `SUPPORTED_INTERFACE_ORIENTATIONS` is not a
valid per-target setting in this project. Verified in the built app's
`Info.plist`.

## D005 — App icon generated programmatically
Date: 2026-09-23. The 1024 pt icon is rendered with a Swift/CoreGraphics script
(glossy black ball, white "8" emblem) into `Assets.xcassets/AppIcon.appiconset`.
No design asset was provided beyond the spec description and approved concept.

## D006 — Bootstrap `opencode.json` created conservatively
Date: 2026-09-23. `AGENTS.md` says to copy `opencode.json` from the template
repo, which is not accessible from this workspace, so a minimal conservative
config was written instead: edit allowed except `AGENTS.md`/`opencode.json`,
bash default-ask with read-only git + `xcodebuild` + `scripts/verify.sh`
allowed, external-directory access ask. Broaden only with a note here and in
`AGENTS.md`.
