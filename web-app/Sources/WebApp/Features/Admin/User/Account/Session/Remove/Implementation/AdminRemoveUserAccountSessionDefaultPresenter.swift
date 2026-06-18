import HTML
import Hummingbird
import SGML

struct AdminRemoveUserAccountSessionDefaultPresenter:
    AdminRemoveUserAccountSessionPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        state: UserAccountSessionConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove session",
            description: "Remove confirmation for user account session",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountSessionConfirmation(state: state)
        )
    }

    func errorPage(
        accountId: String,
        sessionId: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove session",
            description: "Remove confirmation for user account session",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(
                        accountId: accountId,
                        sessionId: sessionId
                    )
                )
            )
        )
    }

    func breadcrumb(
        accountId: String,
        sessionId: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Accounts", link: "/admin/user/accounts/"),
                .init(
                    label: "Details",
                    link: "/admin/user/accounts/\(accountId)/"
                ),
                .init(
                    label: "Remove session",
                    link:
                        "/admin/user/accounts/\(accountId)/sessions/\(sessionId)/remove/"
                ),
            ]
        )
    }
}
