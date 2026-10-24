import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Page.Router.Routes

        func renderAddPage(
            state: Page.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add page",
                content: Page.Add.Component(
                    state: .init(
                        form: state,
                        breadcrumb: routes.breadcrumb,
                        routes: routes
                    )
                )
            )
        }

    }
}
