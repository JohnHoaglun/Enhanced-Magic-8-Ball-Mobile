import Testing
@testable import Enhanced_Magic_8_Ball

struct RepeatingRandomSource: BallRandomSource {
    let value: Double

    mutating func nextUnitRandom() -> Double {
        value
    }
}

struct ScriptedRandomSource: BallRandomSource {
    private var values: [Double]

    init(values: [Double]) {
        self.values = values
    }

    mutating func nextUnitRandom() -> Double {
        values.isEmpty ? 0.0 : values.removeFirst()
    }
}

private func categorySets(_ catalog: SayingCatalog) -> [OutcomeCategory: Set<String>] {
    OutcomeCategory.allCases.reduce(into: [:]) { result, category in
        result[category] = Set(catalog.sayings(in: category))
    }
}

@Suite("SayingCatalog")
struct CatalogTests {
    private let catalog = SayingCatalog.builtin

    @Test
    func builtinCatalogContains101Sayings() {
        #expect(catalog.sayings(in: .affirmative).count == 42)
        #expect(catalog.sayings(in: .noncommittal).count == 28)
        #expect(catalog.sayings(in: .negative).count == 31)
        #expect(catalog.totalSayingCount == 101)
    }

    @Test
    func builtinCatalogContainsAllOriginalTwentySayings() {
        let originalTwenty = [
            "It is certain",
            "It is decidedly so",
            "Without a doubt",
            "Yes definitely",
            "You may rely on it",
            "As I see it, yes",
            "Most likely",
            "Outlook good",
            "Yes",
            "Signs point to yes",
            "Reply hazy, try again",
            "Ask again later",
            "Better not tell you now",
            "Cannot predict now",
            "Concentrate and ask again",
            "Don’t count on it",
            "My reply is no",
            "My sources say no",
            "Outlook not so good",
            "Very doubtful",
        ]
        let all = Set(catalog.allSayings())
        for saying in originalTwenty {
            #expect(all.contains(saying), "Missing original saying: \(saying)")
        }
    }

    @Test
    func noSayingRepeatsWithinACategory() {
        for category in OutcomeCategory.allCases {
            let sayings = catalog.sayings(in: category)
            #expect(sayings.count == Set(sayings).count, "Duplicates in \(category)")
        }
    }

    @Test
    func everyPackContributesSayingsToEveryCategory() {
        for pack in catalog.packs {
            for category in OutcomeCategory.allCases {
                #expect(!pack.sayings(in: category).isEmpty, "Pack \(pack.id) missing \(category)")
            }
        }
    }

    @Test
    func sayingsPreserveOriginalCapitalization() {
        let all = Set(catalog.allSayings())
        #expect(all.contains("It is certain"))
        #expect(all.contains("Yes, duh."))
        #expect(all.contains("Very doubtful"))
        #expect(all.contains("Turn it up—this one goes to eleven."))
    }
}

@Suite("Magic8BallEngine")
struct EngineTests {
    private var tinyCatalog: SayingCatalog {
        SayingCatalog(packs: [
            SayingCatalog.Pack(
                id: "tiny",
                name: "Tiny",
                affirmative: ["Alpha", "Beta", "Gamma"],
                noncommittal: [],
                negative: []
            )
        ])
    }

    @Test
    func categorySelectionRespects50_25_25Boundaries() {
        let sets = categorySets(SayingCatalog.builtin)
        let cases: [(Double, OutcomeCategory)] = [
            (0.0, .affirmative),
            (0.4999, .affirmative),
            (0.5, .noncommittal),
            (0.7499, .noncommittal),
            (0.75, .negative),
            (0.9999, .negative),
        ]
        for (value, expected) in cases {
            let engine = Magic8BallEngine(
                catalog: .builtin,
                store: InMemoryDeckStateStore(),
                rng: RepeatingRandomSource(value: value)
            )
            let saying = engine.drawSaying()
            #expect(sets[expected]!.contains(saying), "Expected \(expected), got “\(saying)”")
        }
    }

    @Test
    func sayingsDoNotRepeatWithinACategoryUntilExhausted() {
        let engine = Magic8BallEngine(
            catalog: tinyCatalog,
            store: InMemoryDeckStateStore(),
            rng: SeededRandomSource(seed: 7)
        )
        let drawn = (0..<3).map { _ in engine.drawSaying() }
        #expect(Set(drawn) == Set(["Alpha", "Beta", "Gamma"]))
    }

    @Test
    func deckStatePersistsAcrossEngineInstances() {
        let store = InMemoryDeckStateStore()
        let catalog = tinyCatalog
        let first = Magic8BallEngine(catalog: catalog, store: store, rng: RepeatingRandomSource(value: 0.0))
        first.drawSaying()

        let remaining = store.loadDeck(for: .affirmative)
        #expect(remaining?.count == 2)
        guard let remaining else { return }

        let restored = Magic8BallEngine(catalog: catalog, store: store, rng: RepeatingRandomSource(value: 0.0))
        let rest = (0..<2).map { _ in restored.drawSaying() }
        #expect(rest == remaining.map { catalog.sayings(in: .affirmative)[$0] })
    }

    @Test
    func exhaustedDeckReshufflesAutomatically() {
        let engine = Magic8BallEngine(
            catalog: tinyCatalog,
            store: InMemoryDeckStateStore(),
            rng: SeededRandomSource(seed: 42)
        )
        (0..<3).forEach { _ in engine.drawSaying() }
        let afterExhaustion = engine.drawSaying()
        #expect(Set(["Alpha", "Beta", "Gamma"]).contains(afterExhaustion))
    }

    @Test
    func corruptedPersistedDeckFallsBackToFreshShuffle() {
        let store = InMemoryDeckStateStore()
        store.saveDeck([999, 999], for: .affirmative)
        let engine = Magic8BallEngine(
            catalog: tinyCatalog,
            store: store,
            rng: RepeatingRandomSource(value: 0.0)
        )
        let saying = engine.drawSaying()
        #expect(Set(["Alpha", "Beta", "Gamma"]).contains(saying))
    }

    @Test
    func categoryWeightsApproximateTargetDistribution() {
        let engine = Magic8BallEngine(
            catalog: .builtin,
            store: InMemoryDeckStateStore(),
            rng: SeededRandomSource(seed: 2026)
        )
        let sets = categorySets(SayingCatalog.builtin)
        let totalDraws = 10_000
        var counts: [OutcomeCategory: Int] = [:]
        for _ in 0..<totalDraws {
            let saying = engine.drawSaying()
            let category = OutcomeCategory.allCases.first { sets[$0]!.contains(saying) }!
            counts[category, default: 0] += 1
        }
        let draws = Double(totalDraws)
        #expect(abs(Double(counts[.affirmative]!) / draws - 0.5) < 0.05)
        #expect(abs(Double(counts[.noncommittal]!) / draws - 0.25) < 0.05)
        #expect(abs(Double(counts[.negative]!) / draws - 0.25) < 0.05)
    }
}
