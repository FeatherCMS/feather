import HTML
import Hummingbird
import SGML

struct AdminGetUserAccountDefaultPresenter: AdminGetUserAccountPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminGetUserAccountModel,
        permissions: Set<String>,
        isSessionRemoved: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User account details - Feather CMS",
            description: "Management user account details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountDetails(
                state: .init(
                    account: model,
                    breadcrumb: breadcrumb(id: model.id),
                    permissions: permissions,
                    isSessionRemoved: isSessionRemoved
                )
            )
        )
    }

    func renderSessionsBulkRemoveConfirmation(
        accountId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove selected sessions",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(id: accountId),
                    title: "Remove selected sessions",
                    message:
                        "Are you sure you want to remove these selected sessions? This action will sign the sessions out immediately.",
                    action:
                        "/admin/user/accounts/\(accountId)/sessions/bulk-remove/",
                    cancelLink: "/admin/user/accounts/\(accountId)/",
                    selectedIds: selectedIds
                )
            )
        )
    }

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User account details - Feather CMS",
            description: "Management user account details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Accounts", link: "/admin/user/accounts/"),
            .init(label: "Details", link: "/admin/user/accounts/\(id)/"),
        ])
    }
}
