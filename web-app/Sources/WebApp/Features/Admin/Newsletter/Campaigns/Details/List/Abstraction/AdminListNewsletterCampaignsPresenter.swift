import Hummingbird

protocol AdminListNewsletterCampaignsPresenter: Sendable {
    func render(
        items: [AdminNewsletterCampaignItem],
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>,
        search: String
    ) -> HTMLResponse
}
