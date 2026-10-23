import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormSubmissionDefaultPresenter:
    AdminEditContactFormSubmissionPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    let routes: Contact.Router.Routes

    func renderError(
        formId: String,
        id: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Contact form submission",
            content: Submission.Detail.DetailsView(
                state: .init(
                    formId: formId,
                    item: .init(
                        id: id,
                        formId: formId,
                        status: "received",
                        createdAt: "",
                        email: nil,
                        values: [:]
                    ),
                    error: message,
                    breadcrumb: routes.formSubmissionsBreadcrumb(formId),
                    routes: routes,
                    permissions: .init(Set(permissions.map(PermissionKey.init)))
                )
            )
        )
    }
}
