import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminEditMenuItemDefaultPresenter: AdminEditMenuItemPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        menuId: String,
        id: String,
        state: MenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemEdit(
                state: .init(
                    menuId: menuId,
                    id: id,
                    form: state,
                    breadcrumb: MenuRoutes.breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: MenuRoutes.breadcrumb
                )
            )
        )
    }

}
