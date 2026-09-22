import FeatherAdmin

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func render(item: NewAdminRemoveItemContext) async throws
        -> HTMLResponse
}
