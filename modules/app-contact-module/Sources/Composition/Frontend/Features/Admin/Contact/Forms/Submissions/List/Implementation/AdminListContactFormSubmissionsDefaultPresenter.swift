import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormSubmissionsDefaultPresenter:
    AdminListContactFormSubmissionsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderList(
        formId: String,
        items: [AdminContactFormSubmissionItem],
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
            title: "Contact form submissions",
            permissions: permissions,
            content: ContactFormSubmissionsTable(
                state: .init(
                    formId: formId,
                    items: pageItems,
                    pageState: pageState,
                    search: search,
                    error: error,
                    breadcrumb: ContactAdminRoutes.formSubmissionsBreadcrumb(
                        RouterPath(formId)
                    ),
                    permissions: .init(Set(permissions.map(PermissionKey.init)))
                )
            )
        )
    }

}
