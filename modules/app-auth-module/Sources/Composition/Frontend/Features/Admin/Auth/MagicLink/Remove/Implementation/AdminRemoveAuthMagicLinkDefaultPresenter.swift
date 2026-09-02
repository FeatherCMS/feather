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

struct AdminRemoveAuthMagicLinkDefaultPresenter:
    AdminRemoveAuthMagicLinkPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
            .init(
                label: "Remove",
                link: "/admin/auth/magic-links/\(id)/remove/"
            ),
        ])
    }

    func renderPage(
        id: String,
        credentialId: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Manage user magic links",
            description: "Management user magic link list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthMagicLinkConfirmation(
                state: .init(
                    id: id,
                    credentialId: credentialId,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove user magic link",
            description:
                "Remove confirmation for a management user magic link",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
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
