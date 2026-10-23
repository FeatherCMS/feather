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

extension WebModule.Menu.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebModule.Menu.Router.Routes

        func renderRemovePage(
            item: AdminRemoveItemContext
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: WebModule.Menu.Remove.Confirmation(
                    state: .init(
                        id: item.id,
                        source: item.label,
                        breadcrumb: routes.breadcrumb,
                        routes: routes,
                        nonceToken: nonceToken
                    )
                ),
                size: .small
            )
        }

        func renderErrorPage(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove menu",
                content: MenuError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

    }
}
