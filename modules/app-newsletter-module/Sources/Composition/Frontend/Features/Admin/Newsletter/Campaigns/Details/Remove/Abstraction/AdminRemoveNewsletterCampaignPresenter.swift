import FeatherAdmin

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse
}
