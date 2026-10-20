import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Dashboard.Presenter {
    struct Default: WebAdmin.System.Dashboard.Presenter.Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func renderPage(
            model: WebAdmin.System.Dashboard.Model
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
