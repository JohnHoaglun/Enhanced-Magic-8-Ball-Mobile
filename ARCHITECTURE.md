# Architecture

SwiftUI app, iOS 26.0+, Swift, no third-party dependencies. Layered so the
domain logic is testable without UI or platform state.

## Layers

| Layer | Files | Responsibility |
| --- | --- | --- |
| UI | `ContentView.swift`, `UI/BallView.swift` | SwiftUI views, view model, animation |
| Domain | `Domain/*.swift` | Categories, saying catalog, deck persistence, draw engine |
| Platform adapter | `Domain/DeckStateStore.swift` (`UserDefaultsDeckStateStore`) | Local persistence |

## Key types

### `Domain/OutcomeCategory.swift`
- `OutcomeCategory`: `.affirmative`, `.noncommittal`, `.negative`.
- `selectionWeight`: 0.5 / 0.25 / 0.25.

### `Domain/SayingCatalog.swift`
- `SayingCatalog.Pack`: `id`, `name`, and one `[String]` array per category.
- `SayingCatalog.builtin`: 8 packs — `original-20`, `sarcastic`, `surfer`,
  `sports`, `weather`, `tech`, `movie-inspired`, `rock-inspired` — 101 sayings
  total (42 affirmative, 28 noncommittal, 31 negative).
- `sayings(in:)` flattens all packs for one category; `totalSayingCount`.

### `Domain/DeckStateStore.swift`
- `DeckStateStore` protocol: `loadDeck(for:)`, `saveDeck(_:for:)`, `clear()`.
- `InMemoryDeckStateStore`: deterministic store for tests.
- `UserDefaultsDeckStateStore`: JSON-encoded `[Int]` under
  `magic8ball.deck.<category>` in `UserDefaults.standard`.

### `Domain/Magic8BallEngine.swift`
- `BallRandomSource` (mutating `nextUnitRandom() -> Double`):
  `SystemRandomSource` (production) and `SeededRandomSource` (SplitMix64,
  deterministic tests).
- `Magic8BallEngine.drawSaying()`:
  1. `chooseCategory()` — weighted pick over non-empty categories using
     cumulative weights.
  2. `drawIndex(from:)` — take the front index from the category deck; the
     deck is a Fisher-Yates shuffled index list, recreated when empty.
  3. Persist the remaining deck after every draw.
- Persisted decks are validated (unique, in-range indices); corrupt state
  falls back to a fresh shuffle.

### `ContentView.swift`
- `BallModel` (`@MainActor @Observable`): phases `idle → shaking → revealed`.
  `shake(reduceMotion:)` reveals immediately under Reduce Motion, otherwise
  sets `.shaking` and reveals after a 1-second `Task.sleep`. `askAgain()`
  cancels any pending task and resets to idle.
- `ContentView`: dark radial-gradient background, a 280 pt `BallView`, and an
  `ActionButton` ("Shake the Ball" / disabled "Shaking" / "Ask Again").
  `.preferredColorScheme(.dark)`, `.statusBarHidden()`.

### `UI/BallView.swift`
- `BallView`: glossy black sphere (radial gradient + highlight + soft shadow),
  white circle with a black "8". While rocking, a `TimelineView` drives a ±7°
  rotation and vertical offset (skipped under Reduce Motion).
- `AnswerWindowView` + `TriangleShape`: flat classic-blue triangle with white,
  bottom-aligned text; the triangle grows to fit wrapped text.

## Data flow

```
tap "Shake the Ball"
  → BallModel.shake()
    → 1 s rock (instant under Reduce Motion)
    → Magic8BallEngine.drawSaying()
      → chooseCategory() (weighted 0.5/0.25/0.25)
      → drawIndex(from:) (no-repeat deck; reshuffle when empty; persist)
    → answer set, phase = .revealed
  → AnswerWindowView shows the saying
tap "Ask Again"
  → BallModel.askAgain() → phase = .idle, answer cleared
```

## Testing

- `Enhanced Magic 8 BallTests` (Swift Testing): catalog integrity (total count,
  original-20 presence, per-category uniqueness, pack coverage, capitalization)
  and engine behavior (weight boundaries, no-repeat, persistence across
  instances, reshuffle on exhaustion, corrupt-state fallback, distribution over
  10k draws).
- `Enhanced Magic 8 BallUITests` (XCUITest): shake → reveal → ask-again flow and
  launch performance.
