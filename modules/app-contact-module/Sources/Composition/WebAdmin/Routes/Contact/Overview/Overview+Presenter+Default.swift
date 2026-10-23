import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Contact.Overview.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderOverview(
            model: Contact.Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Contact.Overview.Component(routes: routes)
            )
        }
    }
}
