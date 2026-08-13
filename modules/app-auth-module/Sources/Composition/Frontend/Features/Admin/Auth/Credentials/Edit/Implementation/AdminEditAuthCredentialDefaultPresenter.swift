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

struct AdminEditAuthCredentialDefaultPresenter: AdminEditAuthCredentialPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        id: String,
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit credential",
            description: "Edit a user credential",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthCredentialEdit(
                state: .init(id: id, form: form, breadcrumb: breadcrumb(id: id))
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
            title: "Edit credential",
            description: "Credentials error",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func formState(email: String, password: String = "")
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
                label: "New password",
                value: password,
                error: nil
            ),
            passwordRequired: false,
            error: nil,
            success: nil
        )
    }

    func format(error: OpenAPIRepositoryError) -> String {
        error.errorDescription
    }

    private func breadcrumb(id: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Credentials", link: "/admin/auth/credentials/"),
            .init(label: "Edit", link: "/admin/auth/credentials/\(id)/edit/"),
        ])
    }
}
