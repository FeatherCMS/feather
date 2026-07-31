import Hummingbird

protocol AdminRemoveNewsletterSubscribersPresenter: Sendable {
    func render(
        ids: [String],
        search: String?,
        campaignId: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
