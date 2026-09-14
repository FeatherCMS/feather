import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsNotFoundDefaultPresenter:
    AdminViewAnalyticsNotFoundPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminViewAnalyticsNotFoundModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AnalyticsNotFoundView(model: model)
        )
    }

    func renderDenied(
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "404s",
            content: AnalyticsAdminStatusView(
                breadcrumb: AnalyticsAdminRoutes.breadcrumb,
                title: "Forbidden",
                message: "Your account cannot access 404 analytics."
            )
        )
    }

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "404s",
            content: AnalyticsAdminStatusView(
                breadcrumb: AnalyticsAdminRoutes.breadcrumb,
                title: info,
                message: message
            )
        )
    }
}
