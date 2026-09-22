import FeatherAdmin

protocol AdminAddNewsletterCampaignPresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
