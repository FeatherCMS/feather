import FeatherWebAdmin
import HTML
import Hummingbird
import SGML

struct AdminRemoveAuthSessionDefaultPresenter:
    AdminRemoveAuthSessionPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminRemoveItemContext,
        identityId: String
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AuthSessionRemoveConfirmation(
                state: .init(
                    item: item,
                    identityId: identityId,
                    breadcrumb: AuthSessionRoutes.detailsBreadcrumb(
                        RouterPath(identityId)
                    ),
                    nonceToken: nonceToken
                )
            ),
            size: .small
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove session",
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

    func errorPage(
        item: AdminRemoveItemContext,
        identityId: String,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove session",
            content: AuthSessionError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthSessionRoutes.detailsBreadcrumb(
                        RouterPath(identityId)
                    )
                )
            )
        )
    }

}
