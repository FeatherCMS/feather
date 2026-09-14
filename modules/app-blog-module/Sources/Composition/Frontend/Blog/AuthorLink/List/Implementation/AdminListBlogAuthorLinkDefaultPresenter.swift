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

struct AdminListBlogAuthorLinkDefaultPresenter:
    AdminListBlogAuthorLinkPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        menuId: String,
        model: AdminListBlogAuthorLinkModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            BlogPermissions.AuthorLinks.list.rawValue
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage blog author links",
            content: BlogAuthorLinkTable(
                state: .init(
                    authorId: menuId,
                    canAccess: canAccess,
                    canAdd: permissions.contains(
                        BlogPermissions.AuthorLinks.create.rawValue
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
                    breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                        RouterPath(menuId)
                    ),
                    error: error
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
            title: "Remove blog author links",
            content: NewAdminConfirmation(
                breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                    RouterPath(menuId)
                ),
                pageHeader: .init(
                    title: "Remove blog author links",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: BlogAdminRoutes.authorLinkRemove(RouterPath(menuId))
                    .description,
                cancel: BlogAdminRoutes.authorLinks(RouterPath(menuId))
                    .description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }

}
