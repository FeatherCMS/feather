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
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
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
                selectedItems: [item.label],
                action:
                    NewsletterAdminRoutes.campaignSubscriberRemove(
                        newsletterID: RouterPath(newsletterId),
                        subscriberID: RouterPath(item.id)
                    )
                    .description,
                cancel:
                    NewsletterAdminRoutes.campaignSubscribers(
                        RouterPath(newsletterId)
                    )
                    .description,
                submitLabel: "Remove subscriber",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
