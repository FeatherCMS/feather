import FeatherAdmin
import Hummingbird

struct AdminViewNewsletterOverviewDefaultPresenter:
    AdminViewNewsletterOverviewPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewNewsletterOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewNewsletterOverviewComponent()
        )
    }
}
