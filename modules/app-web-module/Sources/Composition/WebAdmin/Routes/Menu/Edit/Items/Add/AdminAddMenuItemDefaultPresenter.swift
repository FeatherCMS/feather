import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

struct AdminAddMenuItemDefaultPresenter: AdminAddMenuItemPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    let routes: WebModule.Menu.Router.Routes

    func renderAddPage(
        menuId: String,
        state: MenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemAdd(
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
