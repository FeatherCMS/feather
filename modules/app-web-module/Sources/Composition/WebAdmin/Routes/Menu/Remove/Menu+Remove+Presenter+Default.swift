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

extension WebDomain.Menu.Remove.Presenter {
    struct Default: Interface {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

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
            content: WebDomain.Menu.Remove.Confirmation(
                state: .init(
                    id: item.id,
                    source: item.label,
                    breadcrumb: MenuRoutes.breadcrumb,
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
                    breadcrumb: MenuRoutes.breadcrumb
                )
            )
        )
    }

    }
}
