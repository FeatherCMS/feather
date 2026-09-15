import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormsDefaultPresenter: AdminListContactFormsPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderList(
        items: [AdminContactFormDetailsItem],
        search: String,
        isPicker: Bool,
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
            title: "Contact forms",
            content: ContactFormTable(
                state: .init(
                    items: pageItems,
                    pageState: pageState,
                    search: search,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    isPicker: isPicker,
                    breadcrumb: ContactAdminRoutes.formsBreadcrumb
                )
            )
        )
    }

}
