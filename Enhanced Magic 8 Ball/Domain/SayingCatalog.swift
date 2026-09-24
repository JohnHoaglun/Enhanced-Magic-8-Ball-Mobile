import Foundation

struct SayingCatalog: Sendable {
    struct Pack: Sendable {
        let id: String
        let name: String
        let affirmative: [String]
        let noncommittal: [String]
        let negative: [String]

        func sayings(in category: OutcomeCategory) -> [String] {
            switch category {
            case .affirmative: affirmative
            case .noncommittal: noncommittal
            case .negative: negative
            }
        }
    }

    let packs: [Pack]

    init(packs: [Pack]) {
        self.packs = packs
    }

    func sayings(in category: OutcomeCategory) -> [String] {
        packs.reduce(into: [String]()) { $0.append(contentsOf: $1.sayings(in: category)) }
    }

    func allSayings() -> [String] {
        OutcomeCategory.allCases.flatMap { sayings(in: $0) }
    }

    var totalSayingCount: Int {
        allSayings().count
    }

    static let builtin = SayingCatalog(packs: [
        Pack(
            id: "original-20",
            name: "Original 20",
            affirmative: [
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
            ],
            noncommittal: [
                "Reply hazy, try again",
                "Ask again later",
                "Better not tell you now",
                "Cannot predict now",
                "Concentrate and ask again",
            ],
            negative: [
                "Don’t count on it",
                "My reply is no",
                "My sources say no",
                "Outlook not so good",
                "Very doubtful",
            ]
        ),
        Pack(
            id: "sarcastic",
            name: "Sarcastic",
            affirmative: [
                "Yes, duh.",
                "Absolutely, unless you mess it up.",
                "The stars say go for it.",
                "For sure, chief.",
                "Signs point to yep.",
                "Obviously.",
            ],
            noncommittal: [
                "Do I look like Google?",
                "Ask your mom.",
                "Meh.",
                "Again with this?",
                "That’s what you’re asking?",
                "Error 404: Answer not found.",
                "Decide yourself, coward.",
            ],
            negative: [
                "Hard no.",
                "Absolutely not.",
                "Not looking good, chief.",
                "Don’t hold your breath.",
                "Yikes, probably not.",
                "In your dreams.",
            ]
        ),
        Pack(
            id: "surfer",
            name: "Surfer",
            affirmative: [
                "Totally tubular, bro.",
                "Green light, drop in.",
                "Stoke levels are high.",
            ],
            noncommittal: [
                "Check the surf report later.",
                "Paddle out and see.",
            ],
            negative: [
                "Caught in the impact zone.",
                "Complete wipeout.",
                "Flat spell ahead.",
            ]
        ),
        Pack(
            id: "sports",
            name: "Sports",
            affirmative: [
                "Safe!",
                "Nothing but net.",
                "Touchdown!",
            ],
            noncommittal: [
                "Under further review.",
                "Time-out, try again.",
            ],
            negative: [
                "Out of bounds.",
                "Strike three, you’re out.",
                "Defense won this round.",
            ]
        ),
        Pack(
            id: "weather",
            name: "Weather",
            affirmative: [
                "100% chance of clear skies.",
                "High pressure system says yes.",
                "Sunny days ahead.",
            ],
            noncommittal: [
                "Unpredictable microclimate.",
                "Foggy outlook, check back.",
            ],
            negative: [
                "Severe storm warning.",
                "Complete washout.",
                "Blizzard conditions.",
            ]
        ),
        Pack(
            id: "tech",
            name: "Tech",
            affirmative: [
                "Status 200: OK.",
                "Features deployed successfully.",
                "LGTM (Looks good to me).",
            ],
            noncommittal: [
                "System rebooting, try again.",
                "Buffering...",
            ],
            negative: [
                "Error 404: Answer not found.",
                "Access denied.",
                "Hardware failure.",
            ]
        ),
        Pack(
            id: "movie-inspired",
            name: "Movie-Inspired",
            affirmative: [
                "May the Force be with you.",
                "Here’s looking at you, kid.",
                "Show me the money!",
                "There’s no place like home.",
                "Nobody puts Baby in a corner.",
                "Life finds a way.",
                "To infinity and beyond!",
                "I’m king of the world!",
                "Carpe diem. Seize the day.",
            ],
            noncommittal: [
                "I’ll be back.",
                "Why so serious?",
                "Roads? Where we’re going we don’t need roads.",
            ],
            negative: [
                "You can’t handle the truth!",
                "I see dead people.",
                "Keep the change, ya filthy animal.",
            ]
        ),
        Pack(
            id: "rock-inspired",
            name: "’80s & ’90s Rock-Inspired",
            affirmative: [
                "Turn it up—this one goes to eleven.",
                "Stadium lights are calling.",
                "Take the encore.",
                "The chorus says yes.",
                "Plug in and play it loud.",
            ],
            noncommittal: [
                "Wait for the guitar solo.",
                "Check back after the bridge.",
                "The signal is fuzzy.",
                "Let the feedback settle.",
                "One more track should decide it.",
            ],
            negative: [
                "The amp just blew.",
                "That riff isn’t landing.",
                "Save it for the B-side.",
                "The crowd has gone quiet.",
                "Not every song needs a sequel.",
            ]
        ),
    ])
}
