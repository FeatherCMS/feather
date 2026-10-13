import FeatherAdmin

protocol AdminAddNewsletterCampaignPresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderAddError(
        input: NewsletterCampaignAddForm,
        error: AdminAddNewsletterCampaignError,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
