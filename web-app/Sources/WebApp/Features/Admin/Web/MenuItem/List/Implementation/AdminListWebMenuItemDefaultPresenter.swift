import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListWebMenuItemDefaultPresenter:
    AdminListWebMenuItemPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        menuId: String,
        model: AdminListWebMenuItemModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminWeb.Scope.menuItems
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage items - Feather CMS",
                description: "Management item list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: WebMenuItemError(
                    state: .init(
                        info: "Unable to load web menu items.",
                        message: error,
                        breadcrumb: webMenuItemBreadcrumbState(menuId: menuId)
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage items - Feather CMS",
            description: "Management item list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemTable(
                state: .init(
                    menuId: menuId,
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(scope.create),
                    items: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access web menu items.",
                    breadcrumb: webMenuItemBreadcrumbState(menuId: menuId)
                )
            )
        )
    }

    func renderBulkRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected items",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: webMenuItemBreadcrumbState(menuId: menuId),
                    title: "Remove selected items",
                    message:
                        "Are you sure you want to remove these selected items? This action cannot be undone.",
                    action: "/admin/web/menus/\(menuId)/items/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/web/menus/\(menuId)/",
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

    private func webMenuItemBreadcrumbState(
        menuId: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(label: "Menu", link: "/admin/web/menus/\(menuId)/"),
                .init(
                    label: "Items",
                    link: "/admin/web/menus/\(menuId)/items/"
                ),
            ]
        )
    }
}
