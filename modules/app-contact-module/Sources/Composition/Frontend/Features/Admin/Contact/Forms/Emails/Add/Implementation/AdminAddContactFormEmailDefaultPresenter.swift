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
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Add contact form email",
            permissions: permissions,
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
