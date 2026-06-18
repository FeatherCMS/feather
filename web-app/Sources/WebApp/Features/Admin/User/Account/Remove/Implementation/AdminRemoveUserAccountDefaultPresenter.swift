import HTML
import Hummingbird
import SGML

struct AdminRemoveUserAccountDefaultPresenter: AdminRemoveUserAccountPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        state: UserAccountConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove account",
            description: "Remove confirmation for user account",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountConfirmation(state: state)
        )
    }

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove account",
            description: "Remove confirmation for user account",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountError(
                state: errorState(id: id, error: error)
            )
        )
    }

    func errorState(
        id: String,
        error: OpenAPIRepositoryError
    ) -> UserAccountError.State {
        .init(
            info: infoText(for: error),
            message: messageText(for: error),
            breadcrumb: breadcrumb(id: id)
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Accounts", link: "/admin/user/accounts/"),
                .init(
                    label: "Remove",
                    link: "/admin/user/accounts/\(id)/remove"
                ),
            ]
        )
    }

    private func infoText(
        for error: OpenAPIRepositoryError
    ) -> String {
        error.errorTitle
    }

    private func messageText(
        for error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }
}
