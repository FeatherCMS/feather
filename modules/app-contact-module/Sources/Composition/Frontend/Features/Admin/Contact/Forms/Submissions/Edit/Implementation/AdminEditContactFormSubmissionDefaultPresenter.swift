import FeatherAdmin
import FeatherContracts
import FeatherValidation
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

    func renderError(
        formId: String,
        id: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form submission",
            content: ContactFormSubmissionDetailsView(
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
                    breadcrumb: ContactAdminRoutes.breadcrumb,
                    permissions: .init(Set(permissions.map(PermissionKey.init)))
                )
            )
        )
    }
}
