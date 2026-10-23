import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderPage(
            formId: String,
            mail: AdminContactFormEmail,
            availableFields: [AdminContactFormFieldOption],
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit contact form email",
                content: SubmissionMail.Edit.Form(
                    formId: formId,
                    mail: mail,
                    availableFields: availableFields,
                    breadcrumb: routes.formEmailsBreadcrumb(formId),
                    error: error,
                    routes: routes
                )
            )
        }
    }
}
