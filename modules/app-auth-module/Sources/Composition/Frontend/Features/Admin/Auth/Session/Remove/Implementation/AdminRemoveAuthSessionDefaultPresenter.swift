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
                    breadcrumb: breadcrumb(
                        identityId: identityId,
                        sessionId: item.id
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        return try await renderingEngine.renderNewAdminPage(
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
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove session",
            content: AuthSessionError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(
                        identityId: identityId,
                        sessionId: item.id
                    )
                )
            )
        )
    }

    func breadcrumb(
        identityId: String,
        sessionId: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Identities", link: "/admin/user/identities/"),
            .init(
                label: "Details",
                link: "/admin/user/identities/\(identityId)/"
            ),
        ]
    }
}
