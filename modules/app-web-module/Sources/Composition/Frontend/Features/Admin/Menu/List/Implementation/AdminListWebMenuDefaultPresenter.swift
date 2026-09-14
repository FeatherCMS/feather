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
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(WebPermissions.Menus.list.rawValue)
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
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage menus",
            content: WebMenuTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        WebPermissions.Menus.create.rawValue
                    ),
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
                cancel: ListRemoveRedirect.location(
                    path: WebMenuRoutes.list.description,
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

    private func webMenuBreadcrumbState() -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
            ]
    }
}
