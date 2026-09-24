import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormDefaultPresenter: AdminRemoveContactFormPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws
        -> HTMLResponse
    {
        guard items.count == 1, let item = items.first else {
            return try await renderBulkRemovePage(items: items)
        }
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact form",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact form",
                    description: "This action cannot be undone."
                ),
                selectedItems: [item.label],
                action: ContactAdminRoutes.formRemove.description,
                cancel: ContactAdminRoutes.forms.description,
                submitLabel: "Remove form",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }

    private func renderBulkRemovePage(
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove contact forms",
            content: NewAdminRemoveConfirmation(
                breadcrumb: ContactAdminRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove contact forms",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: ContactAdminRoutes.formRemove.description,
                cancel: ContactAdminRoutes.forms.description,
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                }
            )
        )
    }

}
