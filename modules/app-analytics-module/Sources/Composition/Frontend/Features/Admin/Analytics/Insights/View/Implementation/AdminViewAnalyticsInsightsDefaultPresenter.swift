import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsInsightsDefaultPresenter:
    AdminViewAnalyticsInsightsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        page: AdminAnalyticsInsightsPage,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: page.source.pageTitle,
            content: AnalyticsInsightsView(page: page)
        )
    }

    func renderError(
        source: AdminAnalyticsInsightsPage.Source,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: source.pageTitle,
            content: AnalyticsAdminStatusView(
                breadcrumb: AnalyticsAdminRoutes.breadcrumb,
                title: info,
                message: message
            )
        )
    }

    func renderDenied(
        source: AdminAnalyticsInsightsPage.Source,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: source.pageTitle,
            content: AnalyticsAdminStatusView(
                breadcrumb: AnalyticsAdminRoutes.breadcrumb,
                title: "Forbidden",
                message: "Your account cannot access analytics insights."
            )
        )
    }
}
