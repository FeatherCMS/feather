import AnalyticsModule
import FeatherWebAdmin

extension NotFound.View {
    enum Presenter {}
}

extension NotFound.View.Presenter {
    protocol Interface: Sendable {
        func render(
            model: NotFound.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDenied(
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
