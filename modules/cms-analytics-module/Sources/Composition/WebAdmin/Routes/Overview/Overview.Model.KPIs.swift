import AnalyticsModule

extension Overview.Model {
    struct KPIs: Sendable {
        let totalRequests: Int
        let averageRequestsPerDay: Double
        let authenticatedRequests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
        let pageViews: Int
        let searchRequests: Int
        let botRequests: Int
        let aiRequests: Int
        let humanRequests: Int
        let uniqueVisitors: Int
    }
}
