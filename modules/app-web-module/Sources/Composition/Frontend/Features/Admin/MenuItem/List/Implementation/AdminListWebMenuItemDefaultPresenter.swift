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
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(
            Set(
                WebPermissions.MenuItems.allPermissions()
                    .filter {
                        permissions.contains($0.rawValue)
                    }
            )
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
        guard actions.allows(WebPermissions.MenuItems.list) else {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage items",
                content: WebMenuItemError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web menu items.",
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
                    permissions: actions,
                    items: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search,
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
                action: WebMenuItemRoutes.remove(RouterPath(menuId))
                    .description,
                cancel: NewAdminLocation.url(
                    path: WebMenuItemRoutes.list(RouterPath(menuId))
                        .description,
                    page: page,
                    search: search
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
