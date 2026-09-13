import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminGetUserOverviewDefaultPresenter: AdminGetUserOverviewPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(model: AdminGetUserOverviewModel) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminGetUserOverviewComponent()
        )
    }
}
