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

extension MenuItem.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: MenuItem.Router.Routes

        func renderRemovePage(
            menuId: String,
            item: AdminRemoveItemContext,
            origin: MenuItem.Router.Routes.RemoveOrigin
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: MenuItem.Remove.Confirmation(
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
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit menu",
                content: WebModule.MenuItem.Error.Page(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.itemBreadcrumb(menuId)
                    )
                )
            )
        }
    }
}
