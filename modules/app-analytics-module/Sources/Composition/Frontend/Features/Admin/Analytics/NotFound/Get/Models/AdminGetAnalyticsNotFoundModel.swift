import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

enum AdminAnalyticsNotFoundRange: String, Sendable {
    case last24Hours = "24h"
    case last7Days = "7d"
    case last30Days = "30d"

    var label: String {
        switch self {
        case .last24Hours: "Last 24 hours"
        case .last7Days: "Last 7 days"
        case .last30Days: "Last 30 days"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .last24Hours: 86_400
        case .last7Days: 86_400 * 7
        case .last30Days: 86_400 * 30
        }
    }
}

struct AdminGetAnalyticsNotFoundModel: Sendable {
    let title: String
    let description: String
    let selectedRange: AdminAnalyticsNotFoundRange
    let overview:
        AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
