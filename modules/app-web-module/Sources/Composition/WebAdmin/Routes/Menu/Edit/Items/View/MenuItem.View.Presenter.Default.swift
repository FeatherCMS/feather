import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension MenuItem.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: MenuItem.Router.Routes

        func renderDetailsPage(
            model: MenuItem.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuItem.View.Page(
                    state: .init(
                        item: model,
                        breadcrumb: routes.itemBreadcrumb(model.menuId),
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            menuId: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: WebModule.MenuItem.Error.Page(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.itemBreadcrumb(menuId)
                    )
                )
            )
        }

    }
}
