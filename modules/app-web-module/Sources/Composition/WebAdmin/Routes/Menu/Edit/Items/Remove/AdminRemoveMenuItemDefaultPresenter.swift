import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebDomain
import WebModule

struct AdminRemoveMenuItemDefaultPresenter:
    AdminRemoveMenuItemPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    let routes: WebModule.Menu.Router.Routes

    func renderRemovePage(
        menuId: String,
        item: AdminRemoveItemContext,
        origin: WebModule.Menu.Router.Routes.RemoveOrigin
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
                    breadcrumb: routes.itemBreadcrumb(menuId),
                    nonceToken: nonceToken,
                    origin: origin,
                    routes: routes
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
        origin: WebModule.Menu.Router.Routes.RemoveOrigin
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: routes.itemBreadcrumb(menuId)
                )
            )
        )
    }

}
