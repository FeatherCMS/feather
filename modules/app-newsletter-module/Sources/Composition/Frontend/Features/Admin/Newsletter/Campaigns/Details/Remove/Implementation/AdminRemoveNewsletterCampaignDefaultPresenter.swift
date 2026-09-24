import FeatherAdmin
import Hummingbird

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func render(item: NewAdminRemoveItemContext) async throws
        -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
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
                selectedItems: [item.label],
                action:
                    NewsletterAdminRoutes.campaignRemove(RouterPath(item.id))
                    .description,
                cancel: NewsletterAdminRoutes.campaigns.description,
                submitLabel: "Remove campaign",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
