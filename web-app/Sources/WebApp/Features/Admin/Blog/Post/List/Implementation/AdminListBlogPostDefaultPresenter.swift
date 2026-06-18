import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListBlogPostDefaultPresenter:
    AdminListBlogPostPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogPostModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPublished: Bool,
        isUnpublished: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminBlog.Scope.posts
        let canAccess = permissions.contains(scope.permission(for: .list))
        let canEdit = permissions.contains(scope.permission(for: .update))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage blog posts - Feather CMS",
                description: "Management blog post list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: BlogPostError(
                    state: .init(
                        info: "Unable to load blog posts.",
                        message: error,
                        breadcrumb: blogPostBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage blog posts - Feather CMS",
            description: "Management blog post list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostTable(
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
                        "Your account cannot access blog posts.",
                    breadcrumb: blogPostBreadcrumbState()
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
                    breadcrumb: blogPostBreadcrumbState(),
                    title: "Remove selected pages",
                    message:
                        "Are you sure you want to remove these selected pages? This action cannot be undone.",
                    action: "/admin/blog/posts/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/blog/posts/",
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

    private func blogPostBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Posts", link: "/admin/blog/posts/"),
            ]
        )
    }
}
