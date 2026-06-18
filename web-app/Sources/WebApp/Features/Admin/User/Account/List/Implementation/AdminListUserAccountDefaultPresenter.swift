import Foundation
import Hummingbird

struct AdminListUserAccountDefaultPresenter:
    AdminListUserAccountPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: UserAccountTable.State
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User accounts",
            description: "List of user accounts",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: state.permissions
            ),
            content: UserAccountTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "User accounts",
            description: "List of user accounts",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: []
            ),
            content: UserAccountError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderBulkRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected accounts",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected accounts",
                    message:
                        "Are you sure you want to remove these selected accounts? This action cannot be undone.",
                    action: "/admin/user/accounts/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/user/accounts/",
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
                .init(label: "Accounts", link: "/admin/user/accounts/"),
            ]
        )
    }
}
