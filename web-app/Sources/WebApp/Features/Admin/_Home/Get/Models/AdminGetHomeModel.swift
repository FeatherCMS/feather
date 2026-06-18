import Foundation

struct AdminGetHomeModel: Sendable {
    struct ContentStat: Sendable {
        let label: String
        let value: String
    }

    struct TrafficPoint: Sendable {
        let bucket: Double
        let requests: Int
    }

    struct BreakdownItem: Sendable {
        let label: String
        let count: Int
        let share: Double
    }

    struct InsightCard: Sendable {
        let title: String
        let items: [BreakdownItem]
    }

    struct QuickLinkGroup: Sendable {
        let label: String
        let actions: [QuickLinkAction]
    }

    struct QuickLinkAction: Sendable {
        enum Style: Sendable {
            case primary
            case secondary

            var cssClass: String {
                switch self {
                case .primary:
                    ""
                case .secondary:
                    "secondary"
                }
            }
        }

        let label: String
        let href: String
        let style: Style
    }

    let title: String
    let description: String
    let summary: String
    let contentStats: [ContentStat]
    let dailyTraffic: [TrafficPoint]?
    let topPages: [BreakdownItem]?
    let webInsightCards: [InsightCard]
    let quickLinkGroups: [QuickLinkGroup]
}
