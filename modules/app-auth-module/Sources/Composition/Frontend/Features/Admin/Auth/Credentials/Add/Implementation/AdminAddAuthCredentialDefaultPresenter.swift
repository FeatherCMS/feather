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
        identityId: String,
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
                    identityId: identityId,
                    form: form,
                    breadcrumb: breadcrumb(identityId: identityId)
                )
            )
        )
    }

    func formState(email: String = "", password: String = "")
        -> AuthCredentialForm.State
    {
        .init(
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

    private func breadcrumb(identityId: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Credentials", link: "/admin/auth/credentials/"),
            .init(
                label: "User",
                link: "/admin/auth/credentials/\(identityId)/"
            ),
            .init(
                label: "Add",
                link: "/admin/auth/credentials/\(identityId)/add/"
            ),
        ])
    }
}
