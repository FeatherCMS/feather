public protocol AnalyticsLogFilter: Sendable {
    func shouldTrack(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool
}
