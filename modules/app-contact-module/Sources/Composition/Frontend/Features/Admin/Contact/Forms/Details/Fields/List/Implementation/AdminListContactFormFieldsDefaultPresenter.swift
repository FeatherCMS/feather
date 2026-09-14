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
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let page = request.queryPage()
        let pageSize = 20
        let pageState = NewAdminListPageState(page: page, pageSize: pageSize, total: fields.count)
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, fields.count)
        let pageItems = start < fields.count ? Array(fields[start..<end]) : []
        return renderingEngine.renderNewAdminPage(
            request: request,
            title: "Contact form fields",
            permissions: permissions,
            content: ContactFormFieldsTable(
                state: .init(
                    formId: formId,
                    fields: pageItems,
                    pageState: pageState,
                    search: search,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    permissions: .init(Set(permissions.map(PermissionKey.init))),
                    breadcrumb: ContactAdminRoutes.formFieldsBreadcrumb(
                        RouterPath(formId)
                    )
                )
            )
        )
    }
}
