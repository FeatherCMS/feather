import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListWebPageDefaultPresenter:
    AdminListWebPagePresenter
{
    let request: Request
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
    ) -> HTMLResponse {
        let scope = AdminWeb.Scope.pages
        let canAccess = permissions.contains(scope.permission(for: .list))
        let canEdit = permissions.contains(scope.permission(for: .update))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage web pages - Feather CMS",
                description: "Management web page list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: WebPageError(
                    state: .init(
                        info: "Unable to load web pages.",
                        message: error,
                        breadcrumb: webPageBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage web pages - Feather CMS",
            description: "Management web page list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
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
                        scope.permission(for: .create)
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

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected pages",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: webPageBreadcrumbState(),
                    title: "Remove selected pages",
                    message:
                        "Are you sure you want to remove these selected pages? This action cannot be undone.",
                    action: "/admin/web/pages/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/web/pages/",
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

    private func webPageBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Pages", link: "/admin/web/pages/"),
            ]
        )
    }
}
