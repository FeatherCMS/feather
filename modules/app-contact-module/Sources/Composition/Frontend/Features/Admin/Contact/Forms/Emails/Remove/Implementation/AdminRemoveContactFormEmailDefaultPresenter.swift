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
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove contact form email",
                    description: "This action cannot be undone."
                ),
                selectedItems: [item.label],
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                submit: .init(label: "Remove email", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            ),
            size: .small
        )
    }

    private func renderBulkRemovePage(
        formId: String,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove contact form emails",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: ContactAdminRoutes.formEmailRemove(RouterPath(formId))
                    .description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            ),
            size: .small
        )
    }
}
