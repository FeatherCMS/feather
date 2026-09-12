import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminGetSystemOverviewDefaultPresenter: AdminGetSystemOverviewPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminGetSystemOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminGetSystemOverviewComponent()
        )
    }
}
