import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: WebMenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: WebMenuItemConfirmation(
                state: .init(
                    menuId: menuId,
                    id: item.id,
                    label: item.label,
                    breadcrumb: WebMenuRoutes.breadcrumb,
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
        origin: WebMenuItemRoutes.RemoveOrigin
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMenuRoutes.breadcrumb
                )
            )
        )
    }

}
