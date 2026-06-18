import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListWebMenuDefaultPresenter:
    AdminListWebMenuPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebMenuModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminWeb.Scope.menus
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage menus - Feather CMS",
                description: "Management menu list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: WebMenuError(
                    state: .init(
                        info: "Unable to load web menus.",
                        message: error,
                        breadcrumb: webMenuBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage menus - Feather CMS",
            description: "Management menu list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(scope.create),
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access web menus.",
                    breadcrumb: webMenuBreadcrumbState()
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
            title: "Remove selected menus",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: webMenuBreadcrumbState(),
                    title: "Remove selected menus",
                    message:
                        "Are you sure you want to remove these selected menus? This action cannot be undone.",
                    action: "/admin/web/menus/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/web/menus/",
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

    private func webMenuBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
            ]
        )
    }
}
