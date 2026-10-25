import AnalyticsModule

extension Overview.Model {
    struct Query: Sendable {
        let from: Double
        let to: Double
    }
}
