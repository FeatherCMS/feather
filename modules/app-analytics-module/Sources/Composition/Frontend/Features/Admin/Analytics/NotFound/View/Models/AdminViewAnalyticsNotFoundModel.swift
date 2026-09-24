import AnalyticsAdminAPI

struct AdminViewAnalyticsNotFoundModel: Sendable {
    let title: String
    let description: String
    let from: String
    let to: String
    let overview:
        AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
