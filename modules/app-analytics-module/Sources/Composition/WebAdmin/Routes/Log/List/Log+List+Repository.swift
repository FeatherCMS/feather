import AnalyticsModule

extension Log.List {
    enum Repository {}
}

extension Log.List.Repository {
    protocol Interface: Sendable {
        func listLogs(
            page: Int,
            search: String?,
            source: String?,
            method: String?,
            responseCode: Int?,
            from: Double?,
            to: Double?
        ) async throws -> Log.List.Model
    }
}
