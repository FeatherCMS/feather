import FeatherWebAdmin
import FeatherValidation
import Hummingbird

struct AdminRemoveNewsletterCampaignSubscriberDefaultPresenter:
    AdminRemoveNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        items: [AdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = AdminLocation.removeCancel(
            path:
                NewsletterAdminRoutes.campaignSubscribers(
                    RouterPath(newsletterId)
                )
                .description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AdminRemoveConfirmation(
                header: .primary(
                    title: "Remove campaign subscriber",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action:
                    NewsletterAdminRoutes.campaignSubscriberRemove(
                        RouterPath(newsletterId)
                    )
                    .description,
                submit: .init(label: "Remove subscriber", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                } + [.init(name: "returnTo", value: cancel)]
            ),
            size: .small
        )
    }
}
