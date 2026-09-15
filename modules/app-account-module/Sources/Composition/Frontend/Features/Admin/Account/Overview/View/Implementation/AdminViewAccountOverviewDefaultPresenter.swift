import FeatherAdmin
import Hummingbird

struct AdminViewAccountOverviewDefaultPresenter:
    AdminViewAccountOverviewPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewAccountOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewAccountOverviewComponent()
        )
    }
}
