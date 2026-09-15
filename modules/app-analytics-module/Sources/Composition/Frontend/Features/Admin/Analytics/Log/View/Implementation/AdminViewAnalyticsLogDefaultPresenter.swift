import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsLogDefaultPresenter: AdminViewAnalyticsLogPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminViewAnalyticsLogModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Analytics log details",
            content: AnalyticsLogDetails(
                log: model.log,
                breadcrumb: AnalyticsAdminRoutes.breadcrumb
            )
        )
    }

    func renderErrorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Analytics log details",
            content: AnalyticsAdminStatusView(
                breadcrumb: AnalyticsAdminRoutes.breadcrumb,
                title: "Unable to load analytics log.",
                message: error.errorDescription
            )
        )
    }
}
