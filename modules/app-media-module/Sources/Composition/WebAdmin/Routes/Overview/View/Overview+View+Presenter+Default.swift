import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Overview.View.Presenter {
    struct Default: Overview.View.Presenter.Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Overview.View.Router.Routes

        func renderOverview(
            model: Overview.View.Model
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Overview.View.Content(routes: routes)
            )
        }
    }
}
