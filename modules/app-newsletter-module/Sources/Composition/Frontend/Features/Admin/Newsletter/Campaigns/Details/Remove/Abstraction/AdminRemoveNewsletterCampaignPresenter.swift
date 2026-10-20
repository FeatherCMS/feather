import FeatherWebAdmin

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func renderRemovePage(
        items: [AdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse
}
