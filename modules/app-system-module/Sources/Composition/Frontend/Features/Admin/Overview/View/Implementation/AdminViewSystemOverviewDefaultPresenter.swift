import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminViewSystemOverviewDefaultPresenter: AdminViewSystemOverviewPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewSystemOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewSystemOverviewComponent()
        )
    }
}
