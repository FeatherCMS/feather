import AnalyticsModule
import AnalyticsApplication

extension Log.List {
    enum Interactor {}
}

extension Log.List.Interactor {
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
