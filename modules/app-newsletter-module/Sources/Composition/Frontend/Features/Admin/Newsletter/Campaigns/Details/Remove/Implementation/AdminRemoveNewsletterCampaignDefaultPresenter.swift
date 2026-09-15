import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(id: String, permissions: Set<String>) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove campaign",
            content: NewAdminRemoveConfirmation(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Campaigns",
                        link: NewsletterAdminRoutes.campaigns.description
                    )
                ],
                pageHeader: .init(
                    title: "Remove campaign",
                    description: "This action cannot be undone."
                ),
                action: NewsletterAdminRoutes.campaignRemove(RouterPath(id))
                    .description,
                cancel: NewsletterAdminRoutes.campaigns.description,
                submitLabel: "Remove campaign"
            )
        )
    }
}
