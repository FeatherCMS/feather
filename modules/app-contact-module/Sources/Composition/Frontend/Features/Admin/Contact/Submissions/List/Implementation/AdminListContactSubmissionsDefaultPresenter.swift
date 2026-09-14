import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
    ) -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = NewAdminListPageState(page: page, pageSize: pageSize, total: items.count)
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, items.count)
        let pageItems = start < items.count ? Array(items[start..<end]) : []
        return renderingEngine.renderNewAdminPage(
            request: request,
            title: "Contact submissions",
            permissions: permissions,
            content: ContactSubmissionsTable(
                state: .init(
                    items: pageItems,
                    pageState: pageState,
                    search: search,
                    permissions: .init(Set(permissions.map(PermissionKey.init))),
                    breadcrumb: ContactAdminRoutes.breadcrumb,
                    error: error
                )
            )
        )
    }
}
