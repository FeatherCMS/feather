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

    func renderRemovePage(
        menuId: String,
        page: Int,
        search: String?,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove blog author links",
            content: NewAdminRemoveConfirmation(
                breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                    RouterPath(menuId)
                ),
                pageHeader: .init(
                    title: "Remove blog author links",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: BlogAdminRoutes.authorLinkRemove(RouterPath(menuId))
                    .description,
                cancel: BlogAdminRoutes.authorLinks(RouterPath(menuId))
                    .description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }

}
