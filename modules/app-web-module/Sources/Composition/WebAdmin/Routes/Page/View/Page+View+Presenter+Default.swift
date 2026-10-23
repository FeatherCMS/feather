import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Page.Router.Routes

        func renderDetailsPage(
            rule: Page.Details.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Web page details",
                content: PageDetails(
                    state: .init(
                        rule: rule,
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
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Web page details",
                content: PageError(
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
