import ContactContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFieldDefaultPresenter:
    AdminEditContactFieldPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form field",
            content: ContactFieldEditPage(
                state: .init(
                    field: field,
                    error: error,
                    breadcrumb: ContactAdminRoutes.fieldsBreadcrumb
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form field",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot edit contact form fields."
                ),
                icon: FeatherIcons.alertCircle()
            ),
        )
        return HTMLResponse(content: page.content, status: .forbidden)
    }
}
