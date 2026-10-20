import FeatherAdmin
import Hummingbird
import SystemModule

extension Dashboard.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func renderPage(
            model: Dashboard.Model
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: AdminViewDashboardComponent(model: model)
            )
        }
    }
}
