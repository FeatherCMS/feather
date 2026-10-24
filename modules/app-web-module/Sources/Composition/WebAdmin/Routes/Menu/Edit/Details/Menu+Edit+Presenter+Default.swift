import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebDomain
import WebModule

extension WebModule.Menu.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebModule.Menu.Router.Routes

        func renderEditPage(
            id: String,
            state: WebModule.Menu.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: WebModule.Menu.Edit.Page(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: routes.breadcrumb,
                        routes: MenuItem.Router.Routes(menu: routes)
                    )
                )
            )
        }

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: WebModule.Menu.Error.Page(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

    }
}
