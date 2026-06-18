import AdminOpenAPI
import Foundation

struct AdminAnalyticsInsightsPage: Sendable {

    enum Source: String, Sendable {
        case api = "backend_api"
        case web = "web_app"

        var pageTitle: String {
            switch self {
            case .api:
                "API"
            case .web:
                "Web"
            }
        }

        var pagePath: String {
            switch self {
            case .api:
                "/admin/analytics/api/"
            case .web:
                "/admin/analytics/web/"
            }
        }

        var logsPath: String {
            "/admin/analytics/logs/?source=\(rawValue)"
        }

        var summary: String {
            switch self {
            case .api:
                "Operational visibility for backend API traffic."
            case .web:
                "Audience and content trends for web traffic."
            }
        }
    }

    enum Range: String, Sendable {
        case last24Hours = "24h"
        case last7Days = "7d"
        case last30Days = "30d"

        var label: String {
            switch self {
            case .last24Hours:
                "Last 24 hours"
            case .last7Days:
                "Last 7 days"
            case .last30Days:
                "Last 30 days"
            }
        }

        var duration: TimeInterval {
            switch self {
            case .last24Hours:
                86_400
            case .last7Days:
                86_400 * 7
            case .last30Days:
                86_400 * 30
            }
        }
    }

    let source: Source
    let selectedRange: Range
    let overview: Components.Schemas.AnalyticsLogOverviewSchema
}
