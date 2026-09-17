import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveWebMenuItemDefaultPresenter:
    AdminRemoveWebMenuItemPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove item",
            content: WebMenuItemConfirmation(
                state: .init(
                    menuId: menuId,
                    id: item.id,
                    label: item.label,
                    breadcrumb: WebMenuItemRoutes.breadcrumb(
                        RouterPath(menuId)
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove item",
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMenuItemRoutes.breadcrumb(
                        RouterPath(menuId)
                    )
                )
            )
        )
    }

}
