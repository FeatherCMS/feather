import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminViewUserOverviewDefaultPresenter: AdminViewUserOverviewPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(model: AdminViewUserOverviewModel) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewUserOverviewComponent()
        )
    }
}
