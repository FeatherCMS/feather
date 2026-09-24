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
        search: String?,
        campaignId: String?,
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let list = NewAdminLocation.url(
            path: NewsletterAdminRoutes.subscribers.description,
            search: search,
            queryItems: campaignId?.emptyToNil.map { [("campaignId", $0)] }
                ?? []
        )
        let cancel = returnTo.map {
            NewAdminLocation.removeCancel(
                path: NewsletterAdminRoutes.subscribers.description,
                returnTo: $0
            )
        } ?? list
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove subscribers",
            content: NewAdminRemoveConfirmation(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Subscribers",
                        link: NewsletterAdminRoutes.subscribers.description
                    )
                ],
                pageHeader: .init(
                    title: "Remove selected subscribers",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: NewsletterAdminRoutes.subscriberRemove.description,
                cancel: cancel,
                nonceToken: nonceToken,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                    + (campaignId?.emptyToNil
                        .map { [.init(name: "campaignId", value: $0)] } ?? [])
            )
        )
    }
}
