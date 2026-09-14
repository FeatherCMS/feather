import ContactContracts
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsDefaultPresenter:
    AdminListContactFieldsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderList(
        fields: [AdminContactFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = NewAdminListPageState(page: page, pageSize: pageSize, total: fields.count)
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, fields.count)
        let pageItems = start < fields.count ? Array(fields[start..<end]) : []
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form fields",
            content: ContactFieldsTable(
                state: .init(
                    fields: pageItems,
                    pageState: pageState,
                    search: search,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: ContactAdminRoutes.breadcrumb
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form fields",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot access contact form fields."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: .forbidden)
    }
    private let breadcrumb = ContactAdminRoutes.breadcrumb
}
