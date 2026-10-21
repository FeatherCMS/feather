import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
import Hummingbird

struct AdminListContactSubmissionsDefaultPresenter:
    AdminListContactSubmissionsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = AdminListPageState(
            page: page,
            pageSize: pageSize,
            total: items.count
        )
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, items.count)
        let pageItems = start < items.count ? Array(items[start..<end]) : []
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Contact submissions",
            content: ContactSubmissionsTable(
                state: .init(
                    items: pageItems,
                    pageState: pageState,
                    search: search,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: ContactAdminRoutes.breadcrumb,
                    error: error
                )
            )
        )
    }
}
