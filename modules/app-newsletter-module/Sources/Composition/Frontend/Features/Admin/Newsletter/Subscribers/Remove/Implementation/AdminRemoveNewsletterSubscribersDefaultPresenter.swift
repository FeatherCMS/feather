import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Hummingbird

struct AdminRemoveNewsletterSubscribersDefaultPresenter:
    AdminRemoveNewsletterSubscribersPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        search _: String?,
        campaignId: String?,
        returnTo _: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
                header: .primary(
                    title: "Remove selected subscribers",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: NewsletterAdminRoutes.subscriberRemove.description,
                nonceToken: nonceToken,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                    + (campaignId?.emptyToNil
                        .map { [.init(name: "campaignId", value: $0)] } ?? [])
            ),
            size: .small
        )
    }
}
