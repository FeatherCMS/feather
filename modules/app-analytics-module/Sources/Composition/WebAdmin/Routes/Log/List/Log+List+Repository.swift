import AnalyticsModule
import AnalyticsApplication

extension Log.List {
    enum Repository {}
}

extension Log.List.Repository {
    protocol Interface: Sendable {
        func search(
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
