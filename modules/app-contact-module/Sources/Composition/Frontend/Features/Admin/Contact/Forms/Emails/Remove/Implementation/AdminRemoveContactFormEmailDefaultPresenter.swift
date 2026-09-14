import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormEmailDefaultPresenter:
    AdminRemoveContactFormEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Remove contact form email",
            permissions: permissions,
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form email",
                    description: "This action cannot be undone."
                ),
                selectedItems: [mail.subject],
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formEmails(RouterPath(formId))
                    .description,
                submitLabel: "Remove email",
                hiddenFields: [.init(name: "selectedIds[]", value: mail.id)]
            )
        )
    }

    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderNewAdminPage(
            request: request,
            title: "Remove contact form emails",
            permissions: permissions,
            content: NewAdminConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form emails",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formEmails(RouterPath(formId))
                    .description,
                hiddenFields: selectedIds.map {
                    .init(name: "selectedIds[]", value: $0)
                }
            )
        )
    }
}
