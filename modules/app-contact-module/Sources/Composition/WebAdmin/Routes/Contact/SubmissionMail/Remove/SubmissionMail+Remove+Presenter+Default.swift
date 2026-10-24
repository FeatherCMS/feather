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

extension SubmissionMail.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes

        func renderRemovePage(
            formId: String,
            items: [AdminRemoveItemContext]
        ) async throws -> HTMLResponse {
            guard items.count == 1, let item = items.first else {
                return try await renderBulkRemovePage(
                    formId: formId,
                    items: items
                )
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
                        title: "Remove contact form email",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.label],
                    action: routes.formEmailRemovePath(formId),
                    submit: .init(label: "Remove email", style: .destructive),
                    nonceToken: nonceToken,
                    hiddenFields: [.init(name: "ids", value: item.id)]
                ),
                size: .small
            )
        }

        private func renderBulkRemovePage(
            formId: String,
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
                        title: "Remove contact form emails",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.formEmailRemovePath(formId),
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
