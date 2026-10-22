import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminRemoveMenuItemDefaultPresenter:
    AdminRemoveMenuItemPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: MenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: MenuItemConfirmation(
                state: .init(
                    menuId: menuId,
                    id: item.id,
                    label: item.label,
                    breadcrumb: MenuRoutes.breadcrumb,
                    nonceToken: nonceToken,
                    origin: origin
                )
            ),
            size: .small
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        origin: MenuItemRoutes.RemoveOrigin
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
