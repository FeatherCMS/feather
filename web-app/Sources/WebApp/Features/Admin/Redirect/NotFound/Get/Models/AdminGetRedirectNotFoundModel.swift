import AdminOpenAPI

struct AdminGetRedirectNotFoundModel: Sendable {
    let title: String
    let description: String
    let selectedRange: AdminAnalyticsInsightsPage.Range
    let overview: Components.Schemas.AnalyticsLogOverviewSchema
}
