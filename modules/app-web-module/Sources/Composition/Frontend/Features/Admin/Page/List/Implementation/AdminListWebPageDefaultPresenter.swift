import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebPageDefaultPresenter:
    AdminListWebPagePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebPageModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPublished: Bool,
        isUnpublished: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(WebPermissions.Pages.list.rawValue)
        let canEdit = permissions.contains(WebPermissions.Pages.update.rawValue)
        if let error {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: WebPageError(
                    state: .init(
                        info: "Unable to load web pages.",
                        message: error,
                        breadcrumb: webPageBreadcrumbState()
                    )
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage web pages",
            content: WebPageTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    isPublished: isPublished,
                    isUnpublished: isUnpublished,
                    canAccess: canAccess,
                    canEdit: canEdit,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        WebPermissions.Pages.create.rawValue
                    ),
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access web pages.",
                    breadcrumb: webPageBreadcrumbState()
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
            title: "Remove selected pages",
            content: NewAdminConfirmation(
                breadcrumb: webPageBreadcrumbState(),
                pageHeader: .init(
                    title: "Remove selected pages",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: WebPageRoutes.remove.description,
                cancel: ListRemoveRedirect.location(
                    path: WebPageRoutes.list.description,
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

    private func webPageBreadcrumbState() -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
            ]
    }
}
