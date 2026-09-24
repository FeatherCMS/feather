import FeatherAdmin
import Hummingbird

struct AdminViewRedirectOverviewDefaultPresenter:
    AdminViewRedirectOverviewPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewRedirectOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewRedirectOverviewComponent()
        )
    }
}
