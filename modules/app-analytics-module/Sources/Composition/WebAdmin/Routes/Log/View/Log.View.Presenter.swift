import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared

extension Log.View {
    enum Presenter {}
}

extension Log.View.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Log.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
