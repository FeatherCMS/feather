import FeatherAdmin
import FeatherValidation
import Hummingbird
import WebComponents

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: NewsletterAdminRoutes.campaigns.description,
            returnTo: returnTo
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
                selectedItems: items.map(\.label),
                action: NewsletterAdminRoutes.campaignRemove.description,
                cancel: cancel,
                submitLabel: "Remove campaign",
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                } + [.init(name: "returnTo", value: cancel)]
            )
        )
    }
}
