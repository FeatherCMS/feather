import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            item: AdminRemoveItemContext
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
                        title: "Remove campaign issue",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: [item.label],
                    action: routes.issueRemovePath(
                        newsletterId: newsletterId,
                        issueId: item.id
                    ),
                    submit: .init(label: "Remove issue", style: .destructive),
                    nonceToken: nonceToken,
                    hiddenFields: [.init(name: "ids", value: item.id)]
                ),
                size: .small
            )
        }
    }
}
