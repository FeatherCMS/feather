import FeatherWebAdmin
import AnalyticsModule

extension Log.List {
    enum Presenter {}
}

extension Log.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: Log.List.Model,
            permissions: Set<String>,
            search: String?,
            source: String?,
            method: String?,
            responseCode: String?,
            from: String,
            to: String,
            error: String?
        ) async throws -> HTMLResponse
    }
}
