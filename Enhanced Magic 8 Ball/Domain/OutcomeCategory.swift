import Foundation

enum OutcomeCategory: String, CaseIterable, Codable, Sendable {
    case affirmative
    case noncommittal
    case negative

    var selectionWeight: Double {
        switch self {
        case .affirmative: 0.5
        case .noncommittal: 0.25
        case .negative: 0.25
        }
    }
}
