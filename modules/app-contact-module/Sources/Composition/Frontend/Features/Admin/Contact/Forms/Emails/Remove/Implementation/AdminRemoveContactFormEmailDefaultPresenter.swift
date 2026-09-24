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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        formId: String,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        guard items.count == 1, let item = items.first else {
            return try await renderBulkRemovePage(formId: formId, items: items)
        }
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form email",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form email",
                    description: "This action cannot be undone."
                ),
                selectedItems: [item.label],
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formEmails(RouterPath(formId))
                    .description,
                submitLabel: "Remove email",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }

    private func renderBulkRemovePage(
        formId: String,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form emails",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form emails",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                cancel: ContactAdminRoutes.formEmails(RouterPath(formId))
                    .description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }
}
