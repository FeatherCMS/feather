import FeatherAdmin
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
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path:
                NewsletterAdminRoutes.campaignSubscribers(
                    RouterPath(newsletterId)
                )
                .description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
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
