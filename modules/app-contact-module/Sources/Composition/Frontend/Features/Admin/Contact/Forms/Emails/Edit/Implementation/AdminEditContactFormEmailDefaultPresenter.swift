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
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Edit contact form email",
            permissions: permissions,
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
