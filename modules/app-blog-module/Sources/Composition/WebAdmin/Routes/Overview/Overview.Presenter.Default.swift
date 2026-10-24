import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SGML

extension Overview.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Overview.Router.Routes

        func render(
            model: Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Overview.Component(routes: routes)
            )
        }
    }
}
