import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormEmailDefaultPresenter:
    AdminEditContactFormEmailPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form email",
            content: SubmissionMailEdit(
                formId: formId,
                mail: mail,
                availableFields: availableFields,
                breadcrumb: ContactAdminRoutes.formEmailsBreadcrumb(
                    RouterPath(formId)
                ),
                error: error
            )
        )
    }
}
