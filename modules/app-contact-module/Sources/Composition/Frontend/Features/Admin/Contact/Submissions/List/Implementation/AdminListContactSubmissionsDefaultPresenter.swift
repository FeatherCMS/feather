import FeatherAdmin
import Hummingbird
import FeatherContracts

struct AdminListContactSubmissionsDefaultPresenter:
    AdminListContactSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = NewAdminListPageState(
            page: page,
            pageSize: pageSize,
            total: items.count
        )
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, items.count)
        let pageItems = start < items.count ? Array(items[start..<end]) : []
        return try await renderingEngine.renderNewAdminPage(
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
