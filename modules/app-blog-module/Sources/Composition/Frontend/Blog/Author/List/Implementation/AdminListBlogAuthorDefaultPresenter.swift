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

struct AdminListBlogAuthorDefaultPresenter:
    AdminListBlogAuthorPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogAuthorModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            BlogPermissions.Authors.list.rawValue
        )
        let canEdit = permissions.contains(
            BlogPermissions.Authors.update.rawValue
        )
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Manage blog authors",
            content: BlogAuthorTable(
                state: .init(
                    canAccess: canAccess,
                    canEdit: canEdit,
                    canAdd: permissions.contains(
                        BlogPermissions.Authors.create.rawValue
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
                    breadcrumb: BlogAdminRoutes.authorsBreadcrumb,
                    error: error
                )
            )
        )
    }
}
