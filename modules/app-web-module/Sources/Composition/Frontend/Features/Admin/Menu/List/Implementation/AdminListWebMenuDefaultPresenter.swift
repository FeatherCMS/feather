import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebMenuDefaultPresenter:
    AdminListWebMenuPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebMenuModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(
            Set(
                WebPermissions.Menus.allPermissions().filter {
                    permissions.contains($0.rawValue)
                }
            )
        )
        let canAccess = actions.allows(WebPermissions.Menus.list)
        if let error {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: WebMenuError(
                    state: .init(
                        info: "Unable to load web menus.",
                        message: error,
                        breadcrumb: webMenuBreadcrumbState()
                    )
                )
            )
        }
        guard canAccess else {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage menus",
                content: WebMenuError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web menus.",
                        breadcrumb: webMenuBreadcrumbState()
                    )
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage menus",
            content: WebMenuTable(
                state: .init(
                    permissions: actions,
                    menus: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search ?? "",
                    breadcrumb: webMenuBreadcrumbState()
                )
            )
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected menus",
            content: NewAdminConfirmation(
                breadcrumb: webMenuBreadcrumbState(),
                pageHeader: .init(
                    title: "Remove selected menus",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: WebMenuRoutes.remove.description,
                cancel: NewAdminLocation.url(
                    path: WebMenuRoutes.list.description,
                    page: page,
                    search: search
                ),
                hiddenFields: selectedIds.map {
                    .init(name: "ids", value: $0)
                }
            )
        )
    }

    private func webMenuBreadcrumbState() -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
            ]
    }
}
