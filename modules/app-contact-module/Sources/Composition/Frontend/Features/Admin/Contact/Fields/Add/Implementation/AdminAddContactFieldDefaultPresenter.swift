import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFieldDefaultPresenter:
    AdminAddContactFieldPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
        ])
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form field",
            content: ContactFieldAddView(
                state: .init(
                    key: model.key,
                    type: model.type,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired,
                    position: model.position,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form field",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot create contact form fields."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: .forbidden)
    }
}
