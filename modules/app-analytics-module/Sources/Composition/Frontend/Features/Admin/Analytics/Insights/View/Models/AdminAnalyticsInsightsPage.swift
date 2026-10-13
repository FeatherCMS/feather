import AnalyticsAdminAPI
import Foundation
import Hummingbird

public struct AdminAnalyticsInsightsPage: Sendable {

    public enum Source: String, Sendable {
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
                AnalyticsAdminRoutes.api.description
            case .web:
                AnalyticsAdminRoutes.web.description
            }
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

    let source: Source
    let from: String
    let to: String
    let overview: Components.Schemas.AnalyticsLogOverviewSchema
}
