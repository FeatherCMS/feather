import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormFieldsDefaultPresenter:
    AdminListContactFormFieldsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = NewAdminListPageState(
            page: page,
            pageSize: pageSize,
            total: fields.count
        )
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, fields.count)
        let pageItems = start < fields.count ? Array(fields[start..<end]) : []
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form fields",
            content: ContactFormFieldsTable(
                state: .init(
                    formId: formId,
                    fields: pageItems,
                    pageState: pageState,
                    search: search,
                    error: error,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    breadcrumb: ContactAdminRoutes.formFieldsBreadcrumb(
                        RouterPath(formId)
                    )
                )
            )
        )
    }
}
