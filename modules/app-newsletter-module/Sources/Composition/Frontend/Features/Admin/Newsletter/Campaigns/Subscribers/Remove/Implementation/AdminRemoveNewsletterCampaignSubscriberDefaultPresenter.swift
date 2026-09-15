import FeatherAdmin
import Hummingbird

struct AdminRemoveNewsletterCampaignSubscriberDefaultPresenter:
    AdminRemoveNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        subscriberId: String,
        email: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
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
                selectedItems: [email],
                action:
                    NewsletterAdminRoutes.campaignSubscriberRemove(
                        newsletterID: RouterPath(newsletterId),
                        subscriberID: RouterPath(subscriberId)
                    )
                    .description,
                cancel:
                    NewsletterAdminRoutes.campaignSubscribers(
                        RouterPath(newsletterId)
                    )
                    .description,
                submitLabel: "Remove subscriber"
            )
        )
    }
}
