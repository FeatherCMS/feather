import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormEmailDefaultPresenter:
    AdminAddContactFormEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form email",
            content: SubmissionMailAdd(
                formId: formId,
                mail: .init(
                    id: "",
                    mailFrom: "",
                    mailTo: "",
                    subject: "",
                    additionalHeaders: "",
                    messageBody: ""
                ),
                availableFields: availableFields,
                breadcrumb: ContactAdminRoutes.formEmailsBreadcrumb(
                    RouterPath(formId)
                ),
                error: error
            )
        )
    }
}
