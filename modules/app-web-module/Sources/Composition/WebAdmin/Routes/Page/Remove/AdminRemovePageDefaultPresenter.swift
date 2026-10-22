import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminRemovePageDefaultPresenter:
    AdminRemovePagePresenter
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
            content: PageConfirmation(
                state: .init(
                    id: item.id,
                    source: item.label,
                    breadcrumb: PageRoutes.breadcrumb,
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
            content: PageError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: PageRoutes.breadcrumb
                )
            )
        )
    }

}
