import AdminOpenAPI
import Foundation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListUserRoleDefaultPresenter: AdminListUserRolePresenter {
    let request: Request
    private let permissions = AdminUser.Scope.roles
    private let rolePermissions = AdminAuth.Scope.accessControl
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListUserRoleModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            self.permissions.permission(for: .list)
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage user roles - Feather CMS",
                description: "Management user role list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: UserRoleError(
                    state: .init(
                        info: "Unable to load user roles.",
                        message: error,
                        breadcrumb: breadcrumb()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage user roles - Feather CMS",
            description: "Management user role list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(self.permissions.create),
                    canManageRolePermissions: permissions.contains(
                        rolePermissions.update
                    ),
                    roles: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage: "Your account cannot access user roles.",
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
            title: "Remove selected roles",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected roles",
                    message:
                        "Are you sure you want to remove these selected roles? This action cannot be undone.",
                    action: "/admin/user/roles/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/user/roles/",
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
    ) -> UserRoleError.State {
        .init(
            info: error.errorTitle,
            message: error.errorDescription,
            breadcrumb: breadcrumb()
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Roles", link: "/admin/user/roles/"),
        ])
    }
}
