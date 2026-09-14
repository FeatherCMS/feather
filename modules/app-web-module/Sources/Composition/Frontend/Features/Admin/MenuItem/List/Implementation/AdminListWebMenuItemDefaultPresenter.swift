import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebMenuItemDefaultPresenter:
    AdminListWebMenuItemPresenter
{
    let request: Request
    let context: DefaultRequestContext
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
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            WebPermissions.MenuItems.list.rawValue
        )
        if let error {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage items",
                content: WebMenuItemError(
                    state: .init(
                        info: "Unable to load web menu items.",
                        message: error,
                        breadcrumb: webMenuItemBreadcrumbState(menuId: menuId)
                    )
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage items",
            content: WebMenuItemTable(
                state: .init(
                    menuId: menuId,
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        WebPermissions.MenuItems.create.rawValue
                    ),
                    canReorder: permissions.contains(
                        WebPermissions.MenuItems.update.rawValue
                    ),
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

    func renderRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected items",
            content: NewAdminConfirmation(
                breadcrumb: webMenuItemBreadcrumbState(menuId: menuId),
                pageHeader: .init(
                    title: "Remove selected items",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: WebMenuItemRoutes.remove(RouterPath(menuId)).description,
                cancel: ListRemoveRedirect.location(
                    path: WebMenuItemRoutes.list(RouterPath(menuId)).description,
                    page: page,
                    search: search,
                    title: nil,
                    message: nil
                ),
                hiddenFields: selectedIds.map {
                    .init(name: "ids", value: $0)
                }
            )
        )
    }

    private func webMenuItemBreadcrumbState(
        menuId: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(label: "Menu", link: "/admin/web/menus/\(menuId)/"),
            ]
    }
}
