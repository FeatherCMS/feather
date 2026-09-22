import FeatherAdmin

protocol AdminEditNewsletterCampaignPresenter: Sendable {
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
