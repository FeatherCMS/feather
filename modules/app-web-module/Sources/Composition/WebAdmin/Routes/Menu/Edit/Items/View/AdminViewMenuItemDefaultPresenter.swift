import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMenuItemDefaultPresenter: AdminViewMenuItemPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: MenuItemDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemDetails(
                state: .init(
                    item: rule,
                    breadcrumb: MenuRoutes.breadcrumb
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
