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

struct AdminEditAuthEmailDefaultPresenter: AdminEditAuthEmailPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func formState(
        identityId: String = "",
        identities: [AuthCredentialIdentityOption] = [],
        email: String = ""
    ) -> AuthEmailForm.State {
        .init(
            identityId: .init(
                key: "identity_id",
                label: "Auth email ID",
                value: identityId,
                error: nil
            ),
            identityOptions: identities.map {
                .init(
                    label: $0.label,
                    value: $0.id,
                    isSelected: $0.id == identityId
                )
            },
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
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
            .init(label: "Emails", link: "/admin/auth/emails/"),
            .init(
                label: "Edit",
                link: "/admin/auth/emails/\(id)/edit/"
            ),
        ])
    }

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit user email",
            description: "Edit a management user email",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthEmailEdit(
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
            title: "Edit user email",
            description: "Edit a management user email",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthEmailError(
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
