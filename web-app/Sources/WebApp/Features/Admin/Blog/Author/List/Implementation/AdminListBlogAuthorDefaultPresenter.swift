import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListBlogAuthorDefaultPresenter:
    AdminListBlogAuthorPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogAuthorModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPublished: Bool,
        isUnpublished: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminBlog.Scope.authors
        let canAccess = permissions.contains(scope.permission(for: .list))
        let canEdit = permissions.contains(scope.permission(for: .update))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage blog authors - Feather CMS",
                description: "Management blog author list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: BlogAuthorError(
                    state: .init(
                        info: "Unable to load blog authors.",
                        message: error,
                        breadcrumb: blogAuthorBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage blog authors - Feather CMS",
            description: "Management blog author list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorTable(
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
                        "Your account cannot access blog authors.",
                    breadcrumb: blogAuthorBreadcrumbState()
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
                    breadcrumb: blogAuthorBreadcrumbState(),
                    title: "Remove selected menus",
                    message:
                        "Are you sure you want to remove these selected menus? This action cannot be undone.",
                    action: "/admin/blog/authors/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/blog/authors/",
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

    private func blogAuthorBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Authors", link: "/admin/blog/authors/"),
            ]
        )
    }
}
