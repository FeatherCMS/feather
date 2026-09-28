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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws -> HTMLResponse
    {
        guard items.count == 1, let item = items.first else {
            return try await renderBulkRemovePage(items: items)
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
                    title: "Remove contact form field",
                    description: "This action cannot be undone."
                ),
                selectedItems: [item.label],
                action: ContactAdminRoutes.fieldRemove(RouterPath(item.id))
                    .description,
                submit: .init(label: "Remove field", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            ),
            size: .small
        )
    }

    private func renderBulkRemovePage(
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
                    title: "Remove contact fields",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: ContactAdminRoutes.fieldRemove.description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            ),
            size: .small
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
