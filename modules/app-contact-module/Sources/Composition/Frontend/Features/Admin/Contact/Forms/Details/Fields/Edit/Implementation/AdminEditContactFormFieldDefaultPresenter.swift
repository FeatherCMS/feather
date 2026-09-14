import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormFieldDefaultPresenter:
    AdminEditContactFormFieldPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        formId: String,
        field: AdminContactFormFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Edit contact form field",
            permissions: permissions,
            content: ContactFormFieldEditPage(
                state: .init(
                    formId: formId,
                    field: field,
                    error: error,
                    breadcrumb: ContactAdminRoutes.formFieldsBreadcrumb(
                        RouterPath(formId)
                    )
                )
            )
        )
    }
}
