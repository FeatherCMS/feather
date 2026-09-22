import FeatherAdmin
import FeatherContracts
import Hummingbird

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
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Contact form submission",
            content: ContactFormSubmissionDetailsView(
                state: .init(
                    formId: formId,
                    item: item,
                    error: error,
                    breadcrumb: ContactAdminRoutes.breadcrumb,
                    permissions: .init(Set(permissions.map(PermissionKey.init)))
                )
            )
        )
    }

}
