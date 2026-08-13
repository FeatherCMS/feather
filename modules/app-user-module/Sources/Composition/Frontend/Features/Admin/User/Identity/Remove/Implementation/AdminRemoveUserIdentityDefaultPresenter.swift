import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminRemoveUserIdentityDefaultPresenter: AdminRemoveUserIdentityPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        state: UserIdentityConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove identity",
            description: "Remove confirmation for user identity",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityConfirmation(state: state)
        )
    }

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove identity",
            description: "Remove confirmation for user identity",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityError(
                state: errorState(id: id, error: error)
            )
        )
    }

    func errorState(
        id: String,
        error: OpenAPIRepositoryError
    ) -> UserIdentityError.State {
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
                .init(label: "Identities", link: "/admin/user/identities/"),
                .init(
                    label: "Remove",
                    link: "/admin/user/identities/\(id)/remove"
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
