import AnalyticsModule
import FeatherWebShared
import Foundation
import Hummingbird

extension Insight.View {
    struct Model: Sendable {

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
                    AnalyticsWebAdmin.Router.Routes.api.description
                case .web:
                    AnalyticsWebAdmin.Router.Routes.web.description
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
        let overview: Overview.Model
    }
}
