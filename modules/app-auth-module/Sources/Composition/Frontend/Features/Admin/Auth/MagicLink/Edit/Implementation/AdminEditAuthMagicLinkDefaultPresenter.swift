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

struct AdminEditAuthMagicLinkDefaultPresenter: AdminEditAuthMagicLinkPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

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

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Magic links", link: "/admin/auth/magic-links/"),
            .init(
                label: "Edit",
                link: "/admin/auth/magic-links/\(id)/edit/"
            ),
        ])
    }

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit user magic link - Feather CMS",
            description: "Edit a management user magic link",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthMagicLinkEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: form,
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
            title: "Edit user magic link - Feather CMS",
            description: "Edit a management user magic link",
            imagePath: "images/puppy.png",
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

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
