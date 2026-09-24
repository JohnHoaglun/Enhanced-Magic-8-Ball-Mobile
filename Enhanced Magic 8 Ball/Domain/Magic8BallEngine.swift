import Foundation

protocol BallRandomSource: Sendable {
    mutating func nextUnitRandom() -> Double
}

struct SystemRandomSource: BallRandomSource {
    private var generator = SystemRandomNumberGenerator()

    mutating func nextUnitRandom() -> Double {
        Double(generator.next() >> 11) / Double(1 << 53)
    }
}

struct SeededRandomSource: BallRandomSource {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    private mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }

    mutating func nextUnitRandom() -> Double {
        Double(next() >> 11) / Double(1 << 53)
    }
}

final class Magic8BallEngine {
    private let catalog: SayingCatalog
    private let store: any DeckStateStore
    private var rng: any BallRandomSource
    private var decks: [OutcomeCategory: [Int]]

    init(
        catalog: SayingCatalog = .builtin,
        store: any DeckStateStore,
        rng: any BallRandomSource = SystemRandomSource()
    ) {
        self.catalog = catalog
        self.store = store
        self.rng = rng
        var loaded: [OutcomeCategory: [Int]] = [:]
        for category in OutcomeCategory.allCases {
            loaded[category] = Self.validatedDeck(
                store.loadDeck(for: category),
                category: category,
                catalog: catalog
            )
        }
        decks = loaded
    }

    func drawSaying() -> String {
        let category = chooseCategory()
        let index = drawIndex(from: category)
        return catalog.sayings(in: category)[index]
    }

    private func chooseCategory() -> OutcomeCategory {
        let candidates = OutcomeCategory.allCases.filter { !catalog.sayings(in: $0).isEmpty }
        let totalWeight = candidates.reduce(0) { $0 + $1.selectionWeight }
        var roll = rng.nextUnitRandom() * totalWeight
        for category in candidates {
            roll -= category.selectionWeight
            if roll < 0 {
                return category
            }
        }
        return candidates.last!
    }

    private func drawIndex(from category: OutcomeCategory) -> Int {
        let sayings = catalog.sayings(in: category)
        var deck = decks[category] ?? []
        if deck.isEmpty {
            deck = Self.shuffledIndices(upTo: sayings.count, rng: &rng)
        }
        let index = deck.removeFirst()
        decks[category] = deck
        store.saveDeck(deck, for: category)
        return index
    }

    private static func shuffledIndices(upTo count: Int, rng: inout any BallRandomSource) -> [Int] {
        guard count > 1 else { return Array(0..<count) }
        var indices = Array(0..<count)
        for position in stride(from: indices.count - 1, to: 1, by: -1) {
            let swapIndex = Int(rng.nextUnitRandom() * Double(position + 1)) % (position + 1)
            indices.swapAt(position, swapIndex)
        }
        return indices
    }

    private static func validatedDeck(
        _ loaded: [Int]?,
        category: OutcomeCategory,
        catalog: SayingCatalog
    ) -> [Int] {
        guard let loaded else { return [] }
        let count = catalog.sayings(in: category).count
        let isValid = loaded.count == Set(loaded).count && loaded.allSatisfy { $0 >= 0 && $0 < count }
        return isValid ? loaded : []
    }
}
