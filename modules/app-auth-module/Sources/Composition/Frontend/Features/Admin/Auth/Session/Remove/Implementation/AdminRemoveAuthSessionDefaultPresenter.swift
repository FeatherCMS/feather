import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminRemoveAuthSessionDefaultPresenter:
    AdminRemoveAuthSessionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: NewAdminRemoveItemContext,
        identityId: String
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove session",
            content: AuthSessionRemoveConfirmation(
                state: .init(
                    item: item,
                    identityId: identityId,
                    breadcrumb: AuthSessionRoutes.detailsBreadcrumb(
                        RouterPath(identityId)
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove session",
            content: NewAdminStatusView(
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
        item: NewAdminRemoveItemContext,
        identityId: String,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
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
