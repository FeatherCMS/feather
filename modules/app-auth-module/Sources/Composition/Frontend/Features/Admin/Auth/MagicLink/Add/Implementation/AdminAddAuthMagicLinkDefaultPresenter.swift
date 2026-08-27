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
import WebStandards

struct AdminAddAuthMagicLinkDefaultPresenter: AdminAddAuthMagicLinkPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add user magic link - Feather CMS",
            description: "Add a user magic link in management",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthMagicLinkAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        credentialId: String = "",
        isPersistent: Bool = false
    ) -> AuthMagicLinkForm.State {
        .init(
            credentialId: .init(
                key: "credential_id",
                label: "Credential ID",
                value: credentialId,
                error: nil
            ),
            isPersistent: .init(
                key: "is_persistent",
                label: "Persistent link",
                value: isPersistent,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
            .init(label: "Add", link: "/admin/auth/magic-links/add/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
