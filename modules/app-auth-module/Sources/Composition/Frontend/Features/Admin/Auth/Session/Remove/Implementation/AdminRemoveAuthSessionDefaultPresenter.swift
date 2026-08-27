import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminRemoveAuthSessionDefaultPresenter:
    AdminRemoveAuthSessionPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        state: AuthSessionRemoveConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove session",
            description: "Remove confirmation for user identity session",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthSessionRemoveConfirmation(state: state)
        )
    }

    func errorPage(
        identityId: String,
        sessionId: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove session",
            description: "Remove confirmation for user identity session",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthSessionError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(
                        identityId: identityId,
                        sessionId: sessionId
                    )
                )
            )
        )
    }

    func breadcrumb(
        identityId: String,
        sessionId: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Identities", link: "/admin/user/identities/"),
                .init(
                    label: "Details",
                    link: "/admin/user/identities/\(identityId)/"
                ),
                .init(
                    label: "Remove session",
                    link:
                        "/admin/user/identities/\(identityId)/sessions/\(sessionId)/remove/"
                ),
            ]
        )
    }
}
