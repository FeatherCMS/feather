import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveWebPageDefaultPresenter:
    AdminRemoveWebPagePresenter
{
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
            content: WebPageConfirmation(
                state: .init(
                    id: item.id,
                    source: item.label,
                    breadcrumb: WebPageRoutes.breadcrumb,
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
            title: "Remove page",
            content: WebPageError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebPageRoutes.breadcrumb
                )
            )
        )
    }

}
