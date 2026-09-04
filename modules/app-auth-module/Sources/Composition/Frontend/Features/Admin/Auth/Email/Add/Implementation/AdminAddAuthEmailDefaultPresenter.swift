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
import WebComponents
import WebBuilders

struct AdminAddAuthEmailDefaultPresenter: AdminAddAuthEmailPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add user email",
            description: "Add a user email in management",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthEmailAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        identityId: String = "",
        identities: [AuthCredentialIdentityOption] = []
    ) -> AuthEmailForm.State {
        .init(
            identityId: .init(
                key: "identity_id",
                label: "User identity",
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
            error: nil,
            success: nil
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Emails", link: "/admin/auth/emails/"),
            .init(label: "Add", link: "/admin/auth/emails/add/"),
        ])
    }

    func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
