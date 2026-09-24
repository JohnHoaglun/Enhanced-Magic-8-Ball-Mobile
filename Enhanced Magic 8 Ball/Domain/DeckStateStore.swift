import Foundation

protocol DeckStateStore: Sendable {
    func loadDeck(for category: OutcomeCategory) -> [Int]?
    func saveDeck(_ indices: [Int], for category: OutcomeCategory)
    func clear()
}

final class InMemoryDeckStateStore: DeckStateStore {
    private var decks: [OutcomeCategory: [Int]] = [:]

    func loadDeck(for category: OutcomeCategory) -> [Int]? {
        decks[category]
    }

    func saveDeck(_ indices: [Int], for category: OutcomeCategory) {
        decks[category] = indices
    }

    func clear() {
        decks = [:]
    }
}

struct UserDefaultsDeckStateStore: DeckStateStore {
    private let defaults: UserDefaults
    private let keyPrefix: String

    init(defaults: UserDefaults = .standard, keyPrefix: String = "magic8ball.deck") {
        self.defaults = defaults
        self.keyPrefix = keyPrefix
    }

    private func key(for category: OutcomeCategory) -> String {
        keyPrefix + "." + category.rawValue
    }

    func loadDeck(for category: OutcomeCategory) -> [Int]? {
        guard let data = defaults.data(forKey: key(for: category)) else { return nil }
        return try? JSONDecoder().decode([Int].self, from: data)
    }

    func saveDeck(_ indices: [Int], for category: OutcomeCategory) {
        guard let data = try? JSONEncoder().encode(indices) else { return }
        defaults.set(data, forKey: key(for: category))
    }

    func clear() {
        for category in OutcomeCategory.allCases {
            defaults.removeObject(forKey: key(for: category))
        }
    }
}
