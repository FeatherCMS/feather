import ContactContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFieldDefaultPresenter:
    AdminRemoveContactFieldPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form field",
            content: ContactFieldRemoveView(
                fieldId: fieldId,
                label: label,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Fields", link: ""),
                    .init(label: "Remove", link: ""),
                ])
            )
        )
    }

    func renderConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact fields",
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(label: "Fields", link: "/admin/contact/fields/"),
                        .init(label: "Remove", link: ""),
                    ]),
                    title: "Remove contact fields",
                    message:
                        "Are you sure you want to remove the selected contact fields? This action cannot be undone.",
                    action: "/admin/contact/fields/remove/",
                    cancelLink: "/admin/contact/fields/",
                    selectedIds: selectedIds
                )
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form field",
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot remove contact form fields."
                ),
                icon: FeatherIcons.alertCircle()
            ),
        )
        return HTMLResponse(content: page.content, status: .forbidden)
    }
}
