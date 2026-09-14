import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminListBlogPostDefaultPresenter:
    AdminListBlogPostPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogPostModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            BlogPermissions.Posts.list.rawValue
        )
        let canEdit = permissions.contains(
            BlogPermissions.Posts.update.rawValue
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage blog posts",
            content: BlogPostTable(
                state: .init(
                    canAccess: canAccess,
                    canEdit: canEdit,
                    canAdd: permissions.contains(
                        BlogPermissions.Posts.create.rawValue
                    ),
                    items: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search ?? "",
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                    error: error
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
            title: "Remove blog posts",
            content: NewAdminConfirmation(
                breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                pageHeader: .init(
                    title: "Remove blog posts",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: BlogAdminRoutes.postRemove().description,
                cancel: BlogAdminRoutes.posts.description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }

}
