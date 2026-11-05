import AnalyticsModule

extension Overview.Model {
    struct DailyPoint: Sendable {
        let bucket: Double
        let requests: Int
        let notFoundRequests: Int
        let clientErrorRequests: Int
        let serverErrorRequests: Int
    }
}
