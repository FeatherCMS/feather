import FeatherAdmin
import HTML
import Hummingbird
import SGML
import SystemModule

extension WebAdmin.System.Overview.Presenter {
    struct Default: WebAdmin.System.Overview.Presenter.Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebAdmin.System.Overview.Router.Routes

        func renderOverview(
            model: WebAdmin.System.Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: AdminViewSystemOverviewComponent(routes: routes)
            )
        }
    }
}
