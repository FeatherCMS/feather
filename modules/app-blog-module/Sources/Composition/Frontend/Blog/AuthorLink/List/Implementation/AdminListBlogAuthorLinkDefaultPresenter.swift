import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherWebAdmin
import FeatherModuleKit
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
    let context: AuthenticatedRequestContext
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
        return try await renderEngine.renderAdminPage(
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
}
