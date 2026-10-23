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

extension WebModule.Menu.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebModule.Menu.Router.Routes

        func renderDetailsPage(
            rule: MenuDetailsModel,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Menu details",
                content: MenuDetails(
                    state: .init(
                        menu: rule,
                        breadcrumb: routes.breadcrumb,
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Menu details",
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
