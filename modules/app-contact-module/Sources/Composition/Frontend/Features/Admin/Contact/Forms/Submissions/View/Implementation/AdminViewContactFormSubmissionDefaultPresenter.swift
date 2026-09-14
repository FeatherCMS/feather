import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactFormSubmissionDefaultPresenter:
    AdminViewContactFormSubmissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Contact form submission",
            permissions: permissions,
            content: ContactFormSubmissionDetailsView(
                state: .init(
                    formId: formId,
                    item: item,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    breadcrumb: ContactAdminRoutes.breadcrumb,
                    permissions: .init(Set(permissions.map(PermissionKey.init)))
                )
            )
        )
    }

}
