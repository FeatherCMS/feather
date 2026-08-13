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

struct AdminListAuthCredentialIdentityDefaultPresenter:
    AdminListAuthCredentialIdentityPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthCredentialIdentityTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Credentials",
            description: "Select a user to manage credentials",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: AuthCredentialIdentityTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Credentials",
            description: "Credentials error",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: []
            ),
            content: AuthCredentialError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Auth", link: "/admin/auth/"),
                        .init(
                            label: "Credentials",
                            link: "/admin/auth/credentials/"
                        ),
                    ])
                )
            )
        )
    }
}
