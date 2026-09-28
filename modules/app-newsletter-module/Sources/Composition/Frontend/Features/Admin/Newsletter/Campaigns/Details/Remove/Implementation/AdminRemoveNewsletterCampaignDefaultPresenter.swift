import FeatherAdmin
import Hummingbird

struct AdminRemoveNewsletterCampaignDefaultPresenter:
    AdminRemoveNewsletterCampaignPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: NewsletterAdminRoutes.campaigns.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove campaign",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: NewsletterAdminRoutes.campaignRemove.description,
                submit: .init(label: "Remove campaign", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: items.map {
                    .init(name: "ids", value: $0.id)
                } + [.init(name: "returnTo", value: cancel)]
            ),
            size: .small
        )
    }
}
