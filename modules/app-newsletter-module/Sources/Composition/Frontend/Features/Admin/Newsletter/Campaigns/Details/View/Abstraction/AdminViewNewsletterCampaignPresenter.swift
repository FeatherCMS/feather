import FeatherWebAdmin

protocol AdminViewNewsletterCampaignPresenter: Sendable {
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
