import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML

struct AdminViewWebOverviewDefaultPresenter: AdminViewWebOverviewPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewWebOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewWebOverviewComponent()
        )
    }
}
