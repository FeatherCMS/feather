import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebMenuItemDefaultPresenter: AdminViewWebMenuItemPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMenuItemDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Item details",
            content: WebMenuItemDetails(
                state: .init(
                    item: rule,
                    breadcrumb: WebMenuItemRoutes.menuBreadcrumb(
                        RouterPath(rule.menuId)
                    )
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
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Item details",
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMenuItemRoutes.menuBreadcrumb(
                        RouterPath(menuId)
                    )
                )
            )
        )
    }

}
