import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListBlogAuthorLinkDefaultPresenter:
    AdminListBlogAuthorLinkPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        menuId: String,
        model: AdminListBlogAuthorLinkModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminBlog.Scope.authorLinks
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage blog author links - Feather CMS",
                description: "Management blog author link list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: BlogAuthorLinkError(
                    state: .init(
                        info: "Unable to load blog author links.",
                        message: error,
                        breadcrumb: blogAuthorLinkBreadcrumbState(
                            menuId: menuId
                        )
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage blog author links - Feather CMS",
            description: "Management blog author link list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkTable(
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
                        "Your account cannot access blog author links.",
                    breadcrumb: blogAuthorLinkBreadcrumbState(menuId: menuId)
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
            title: "Remove selected links",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: blogAuthorLinkBreadcrumbState(menuId: menuId),
                    title: "Remove selected links",
                    message:
                        "Are you sure you want to remove these selected links? This action cannot be undone.",
                    action: "/admin/blog/authors/\(menuId)/links/bulk-remove/",
                    cancelLink: "/admin/blog/authors/\(menuId)/",
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func blogAuthorLinkBreadcrumbState(
        menuId: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Authors", link: "/admin/blog/authors/"),
                .init(label: "Author", link: "/admin/blog/authors/\(menuId)/"),
                .init(
                    label: "Links",
                    link: "/admin/blog/authors/\(menuId)/links/"
                ),
            ]
        )
    }
}
