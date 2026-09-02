import FeatherAdmin
import Foundation
import Hummingbird

struct AdminListUserIdentityDefaultPresenter:
    AdminListUserIdentityPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: UserIdentityTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User identities",
            description: "List of user identities",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: UserIdentityTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User identities",
            description: "List of user identities",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: []
            ),
            content: UserIdentityError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected identities",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected identities",
                    message:
                        "Are you sure you want to remove these selected identities? This action cannot be undone.",
                    action: "/admin/user/identities/remove/",
                    cancelLink: ListRemoveRedirect.location(
                        path: "/admin/user/identities/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    ),
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Identities", link: "/admin/user/identities/"),
            ]
        )
    }
}
