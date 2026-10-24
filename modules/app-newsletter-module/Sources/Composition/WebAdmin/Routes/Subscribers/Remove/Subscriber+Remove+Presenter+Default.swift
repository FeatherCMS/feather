import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Subscriber.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Subscriber.Router.Routes

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            search _: String?,
            campaignId: String?,
            returnTo _: String?
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
                        title: "Remove selected subscribers",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.remove.path,
                    nonceToken: nonceToken,
                    hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                        + (campaignId?.emptyToNil
                            .map { [.init(name: "campaignId", value: $0)] }
                            ?? [])
                ),
                size: .small
            )
        }
    }
}
