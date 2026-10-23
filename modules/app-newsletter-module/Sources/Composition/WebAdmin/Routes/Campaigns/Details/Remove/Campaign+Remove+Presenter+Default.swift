import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            let cancel = AdminLocation.removeCancel(
                path: routes.list.path,
                returnTo: returnTo
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove campaign",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.removeSelected.path,
                    submit: .init(
                        label: "Remove campaign",
                        style: .destructive
                    ),
                    nonceToken: nonceToken,
                    hiddenFields: items.map {
                        .init(name: "ids", value: $0.id)
                    } + [.init(name: "returnTo", value: cancel)]
                ),
                size: .small
            )
        }
    }
}
