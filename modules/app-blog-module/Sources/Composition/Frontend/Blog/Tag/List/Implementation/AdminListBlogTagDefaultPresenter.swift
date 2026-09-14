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

struct AdminListBlogTagDefaultPresenter:
    AdminListBlogTagPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogTagModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(BlogPermissions.Tags.list.rawValue)
        let canEdit = permissions.contains(BlogPermissions.Tags.update.rawValue)
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage blog tags",
            content: BlogTagTable(
                state: .init(
                    canAccess: canAccess,
                    canEdit: canEdit,
                    canAdd: permissions.contains(
                        BlogPermissions.Tags.create.rawValue
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
                    breadcrumb: BlogAdminRoutes.tagsBreadcrumb,
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
            title: "Remove blog tags",
            content: NewAdminConfirmation(
                breadcrumb: BlogAdminRoutes.tagsBreadcrumb,
                pageHeader: .init(
                    title: "Remove blog tags",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: BlogAdminRoutes.tagRemove().description,
                cancel: BlogAdminRoutes.tags.description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }

}
