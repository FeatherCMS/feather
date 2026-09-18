import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditWebMenuItemDefaultPresenter: AdminEditWebMenuItemPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        menuId: String,
        id: String,
        state: WebMenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit item",
            content: WebMenuItemEdit(
                state: .init(
                    menuId: menuId,
                    id: id,
                    form: state,
                    breadcrumb: WebMenuItemRoutes.breadcrumb(RouterPath(menuId))
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
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit item",
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMenuItemRoutes.breadcrumb(RouterPath(menuId))
                )
            )
        )
    }

}
