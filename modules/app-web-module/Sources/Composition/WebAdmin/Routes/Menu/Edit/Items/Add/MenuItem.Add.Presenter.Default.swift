import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension MenuItem.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: MenuItem.Router.Routes

        func renderAddPage(
            menuId: String,
            state: MenuItem.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: MenuItem.Add.Page(
                    state: .init(
                        menuId: menuId,
                        form: state,
                        breadcrumb: routes.itemBreadcrumb(menuId),
                        routes: routes
                    )
                )
            )
        }

    }
}
