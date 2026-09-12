import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML

struct AdminGetSystemOverviewDefaultPresenter: AdminGetSystemOverviewPresenter {
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderingEngine: any RenderingEngine

    func renderHome(
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
