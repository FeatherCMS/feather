import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
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

struct AdminAddAuthCredentialDefaultPresenter: AdminAddAuthCredentialPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add credential",
            description: "Add a user credential",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthCredentialAdd(
                state: .init(
                    form: form,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func formState(
        userId: String = "",
        emails: [AuthCredentialIdentityOption] = [],
        email: String = "",
        password: String = ""
    )
        -> AuthCredentialForm.State
    {
        .init(
            identity: .init(
                key: "userId",
                label: "User identity",
                value: userId,
                error: nil
            ),
            identityOptions: emails.map {
                .init(
                    label: $0.label,
                    value: $0.id,
                    isSelected: $0.id == email
                )
            },
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            password: .init(
                key: "password",
                label: "Password",
                value: password,
                error: nil
            ),
            passwordRequired: true,
            error: nil,
            success: nil
        )
    }

    func format(error: OpenAPIRepositoryError) -> String {
        error.errorDescription
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Credentials", link: "/admin/auth/credentials/"),
            .init(label: "Add", link: "/admin/auth/credentials/add/"),
        ])
    }
}
