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
            state: MenuForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuEdit(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: routes.breadcrumb,
                        routes: routes
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
                content: MenuError(
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
