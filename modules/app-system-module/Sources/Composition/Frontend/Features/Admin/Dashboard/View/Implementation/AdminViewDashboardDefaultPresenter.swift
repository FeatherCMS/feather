import FeatherAdmin
import Hummingbird

struct AdminViewDashboardDefaultPresenter: AdminViewDashboardPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminViewDashboardModel
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewDashboardComponent(model: model)
        )
    }
}
