import FeatherAdmin
import Hummingbird

struct AdminGetRedirectOverviewDefaultPresenter:
    AdminGetRedirectOverviewPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminGetRedirectOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminGetRedirectOverviewComponent()
        )
    }
}
