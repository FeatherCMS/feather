import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: ContactModule.Form.Router.Routes

        func renderRemovePage(items: [AdminRemoveItemContext])
            async throws
            -> HTMLResponse
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
                        title: "Remove contact form",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.label],
                    action: routes.formRemove.path,
                    submit: .init(label: "Remove form", style: .destructive),
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
                        title: "Remove contact forms",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.formRemove.path,
                    nonceToken: nonceToken,
                    hiddenFields: items.map {
                        .init(name: "ids", value: $0.id)
                    }
                ),
                size: .small
            )
        }

    }
}
