import AnalyticsModule
import FeatherWebAdmin

extension Insight.View {
    enum Presenter {}
}

extension Insight.View.Presenter {
    protocol Interface: Sendable {
        func render(
            page: Insight.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            source: Insight.View.Model.Source,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDenied(
            source: Insight.View.Model.Source,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
