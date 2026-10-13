import FeatherAdmin
import Hummingbird

struct AdminViewContactOverviewDefaultPresenter:
    AdminViewContactOverviewPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewContactOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewContactOverviewComponent()
        )
    }
}
