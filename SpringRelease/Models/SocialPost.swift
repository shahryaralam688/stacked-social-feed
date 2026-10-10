import Foundation

struct SocialAuthor: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let headline: String
    let avatarURL: URL
}

struct SocialPost: Identifiable, Equatable, Hashable {
    let id: String
    let author: SocialAuthor
    let timeAgo: String
    let body: String
    let imageURL: URL?
    let likes: Int
    let comments: Int
    let reposts: Int
}

enum SocialFeedCatalog {
    /// Current signed-in dummy profile shown in the top bar.
    static let currentUser = SocialAuthor(
        id: "me",
        name: "Ayesha Khan",
        headline: "Product Design Lead · Karachi",
        avatarURL: URL(string: "https://i.pravatar.cc/150?img=47")!
    )

    static let authors: [SocialAuthor] = [
        SocialAuthor(
            id: "a1",
            name: "Marcus Chen",
            headline: "Staff Engineer · Stripe",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=12")!
        ),
        SocialAuthor(
            id: "a2",
            name: "Priya Nair",
            headline: "VP Product · Notion",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=32")!
        ),
        SocialAuthor(
            id: "a3",
            name: "Daniel Okonkwo",
            headline: "Founder · Northline Labs",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=15")!
        ),
        SocialAuthor(
            id: "a4",
            name: "Elena Rossi",
            headline: "Design Systems · Figma",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=5")!
        ),
        SocialAuthor(
            id: "a5",
            name: "Jamal Wright",
            headline: "Growth Marketing · HubSpot",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=68")!
        ),
        SocialAuthor(
            id: "a6",
            name: "Sofia Alvarez",
            headline: "People Ops · Remote-first",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=44")!
        ),
        SocialAuthor(
            id: "a7",
            name: "Kenji Tanaka",
            headline: "AI Research · DeepMind alum",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=60")!
        ),
        SocialAuthor(
            id: "a8",
            name: "Amira Hassan",
            headline: "Partner · Sequoia Scout",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=26")!
        ),
        SocialAuthor(
            id: "a9",
            name: "Owen Blake",
            headline: "Creative Director · Droga5",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=8")!
        ),
        SocialAuthor(
            id: "a10",
            name: "Nadia Petrov",
            headline: "Head of Eng · Linear",
            avatarURL: URL(string: "https://i.pravatar.cc/150?img=9")!
        ),
    ]

    private static let bodies: [String] = [
        "Shipping is a habit, not a hero moment.\n\nWe cut our release checklist from 40 steps to 9. Cycle time dropped 31% in one quarter — mostly by deleting ceremony, not adding tools.",
        "Unpopular take: your roadmap is a conversation, not a contract.\n\nThe best PMs I know rewrite priorities every Monday with sales, support, and eng in the same room.",
        "Design systems aren’t libraries. They’re agreements.\n\nIf your tokens don’t change how product and eng negotiate scope, you built a sticker pack.",
        "I hired three ICs this month who never asked about title.\n\nThey asked about ownership, mentorship, and whether we ship weekly. Culture shows up in the interview questions.",
        "Remote isn’t async by default.\n\nWe blocked 2pm–4pm for deep work company-wide. Meeting load fell, and so did Slack panic. Boundaries beat tools.",
        "Customer quotes beat dashboards when you’re deciding what to kill.\n\nWe archived two “strategic” features after reading 12 support tickets aloud in planning.",
        "AI won’t replace craft — it will expose the people who never had it.\n\nPrompting is cheap. Taste, judgment, and editing still compound.",
        "The quietest engineers often write the clearest RFCs.\n\nWe started promoting based on written influence, not meeting airtime. Retention improved.",
        "Brand is what happens when marketing leaves the room.\n\nYour error states, empty screens, and onboarding copy are the campaign most users actually see.",
        "Fundraising tip nobody puts on slides: answer the second question first.\n\nInvestors already have the market map. They want to know why you win the ugly edge cases.",
    ]

    private static let imageIDs = [1015, 1011, 1036, 1043, 1050, 1067, 1074, 1080, 1084, 129]

    static func makeFeed(seed: Int = 0) -> [SocialPost] {
        let count = 9
        return (0..<count).map { i in
            let rotated = (i + seed) % authors.count
            let author = authors[rotated]
            let body = bodies[(i + seed) % bodies.count]
            let imageID = imageIDs[(i + seed * 3) % imageIDs.count]
            let hasImage = i % 4 != 2
            return SocialPost(
                id: "post-\(seed)-\(i)-\(author.id)",
                author: author,
                timeAgo: relativeTime(index: i),
                body: body,
                imageURL: hasImage
                    ? URL(string: "https://picsum.photos/id/\(imageID)/900/560")
                    : nil,
                likes: 40 + ((i * 37 + seed * 11) % 420),
                comments: 3 + ((i * 13 + seed) % 48),
                reposts: (i * 5 + seed) % 22
            )
        }
    }

    private static func relativeTime(index: Int) -> String {
        switch index {
        case 0: return "12m"
        case 1: return "1h"
        case 2: return "2h"
        case 3: return "4h"
        case 4: return "Yesterday"
        case 5: return "1d"
        case 6: return "2d"
        case 7: return "3d"
        default: return "1w"
        }
    }
}
