import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension FormField.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderRemovePage(items: [AdminRemoveItemContext])
            async throws -> HTMLResponse
        {
            guard items.count == 1, let item = items.first else {
                return try await renderBulkRemovePage(items: items)
            }
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove contact form field",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.label],
                    action: routes.fieldRemovePath(item.id),
                    submit: .init(label: "Remove field", style: .destructive),
                    nonceToken: nonceToken,
                    hiddenFields: [.init(name: "ids", value: item.id)]
                ),
                size: .small
            )
        }

        private func renderBulkRemovePage(
            items: [AdminRemoveItemContext]
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove contact fields",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.fieldsRemove.path,
                    nonceToken: nonceToken,
                    hiddenFields: items.map {
                        .init(name: "ids", value: $0.id)
                    }
                ),
                size: .small
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove contact form field",
                content: AdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message:
                            "Your account cannot remove contact form fields."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: .forbidden)
        }
    }
}
