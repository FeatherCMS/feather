import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListUserInvitationDefaultPresenter:
    AdminListUserInvitationPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListUserInvitationModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminUser.Scope.invitations
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage user invitations - Feather CMS",
                description: "Management user invitation list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: UserInvitationError(
                    state: .init(
                        info: "Unable to load user invitations.",
                        message: error,
                        breadcrumb: breadcrumb()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage user invitations - Feather CMS",
            description: "Management user invitation list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserInvitationTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(scope.create),
                    invitations: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access user invitations.",
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected invitations",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected invitations",
                    message:
                        "Are you sure you want to remove these selected invitations? This action cannot be undone.",
                    action: "/admin/user/invitations/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/user/invitations/",
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

    func errorState(
        error: OpenAPIRepositoryError
    ) -> UserInvitationError.State {
        .init(
            info: error.errorTitle,
            message: error.errorDescription,
            breadcrumb: breadcrumb()
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/user/invitations/"),
        ])
    }
}
