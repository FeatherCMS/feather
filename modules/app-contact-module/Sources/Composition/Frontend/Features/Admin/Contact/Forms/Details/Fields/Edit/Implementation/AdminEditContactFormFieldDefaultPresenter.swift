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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        formId: String,
        field: AdminContactFormFieldRow,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form field",
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
