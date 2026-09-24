import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsOverviewDefaultPresenter:
    AdminViewAnalyticsOverviewPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewAnalyticsOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewAnalyticsOverviewComponent()
        )
    }
}
