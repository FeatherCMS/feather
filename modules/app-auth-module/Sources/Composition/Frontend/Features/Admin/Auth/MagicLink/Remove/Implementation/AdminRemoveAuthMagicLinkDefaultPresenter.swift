import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminRemoveAuthMagicLinkDefaultPresenter:
    AdminRemoveAuthMagicLinkPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        item: AdminRemoveItemContext,
        credentialId: String
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AuthMagicLinkConfirmation(
                state: .init(
                    item: item,
                    credentialId: credentialId,
                    breadcrumb: AuthMagicLinkRoutes.breadcrumb,
                    nonceToken: nonceToken
                )
            ),
            size: .small
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove user magic link",
            content: AdminStatusView(
                state: .init(
                    title: "Form expired",
                    message:
                        "This form is no longer valid. Please reload the page."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func renderError(
        item: AdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove user magic link",
            content: AuthMagicLinkError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthMagicLinkRoutes.breadcrumb
                )
            )
        )
    }
}
