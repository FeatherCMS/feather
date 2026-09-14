import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminRemoveNewsletterSubscribersDefaultPresenter:
    AdminRemoveNewsletterSubscribersPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        ids: [String],
        search: String?,
        campaignId: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let cancel = NewAdminLocation.url(
            path: NewsletterAdminRoutes.subscribers.description,
            search: search,
            queryItems: campaignId?.emptyToNil.map { [("campaignId", $0)] }
                ?? []
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove subscribers",
            content: NewAdminConfirmation(
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
                selectedItems: ids,
                action: NewsletterAdminRoutes.subscriberRemove.description,
                cancel: cancel,
                hiddenFields: ids.map { .init(name: "selectedIds", value: $0) }
                    + (campaignId?.emptyToNil
                        .map { [.init(name: "campaignId", value: $0)] } ?? [])
            )
        )
    }
}
