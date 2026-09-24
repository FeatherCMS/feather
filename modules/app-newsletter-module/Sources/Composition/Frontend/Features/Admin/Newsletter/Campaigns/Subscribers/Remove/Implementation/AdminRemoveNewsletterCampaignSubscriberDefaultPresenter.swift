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
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove campaign subscriber",
            content: NewAdminRemoveConfirmation(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Subscribers",
                        link:
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(newsletterId)
                            )
                            .description
                    )
                ],
                pageHeader: .init(
                    title: "Remove campaign subscriber",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action:
                    NewsletterAdminRoutes.campaignSubscriberRemove(
                        RouterPath(newsletterId)
                    )
                    .description,
                cancel: cancel,
                submitLabel: "Remove subscriber",
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                } + [.init(name: "returnTo", value: cancel)]
            )
        )
    }
}
