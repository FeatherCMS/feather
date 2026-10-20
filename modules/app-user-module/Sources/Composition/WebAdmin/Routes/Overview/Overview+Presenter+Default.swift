import FeatherWebAdmin
import Hummingbird
import WebComponents

extension Overview.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Overview.Router.Routes

        func renderPage(model: Overview.Model) async throws
            -> HTMLResponse
        {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Overview.View(routes: routes)
            )
        }
    }
}
