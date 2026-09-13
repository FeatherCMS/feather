import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminRemoveAuthMagicLinkDefaultPresenter:
    AdminRemoveAuthMagicLinkPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
        ]
    }

    func renderPage(
        id: String,
        credentialId: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user magic links",
            content: AuthMagicLinkConfirmation(
                state: .init(
                    id: id,
                    credentialId: credentialId,
                    breadcrumb: breadcrumb(id: id),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user magic link",
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

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user magic link",
            content: AuthMagicLinkError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }
}
