import FeatherAdmin

protocol AdminListNewsletterCampaignsPresenter: Sendable {
    func render(
        model: AdminListModel<AdminNewsletterCampaignItem>,
        isPicker: Bool,
        error: String?,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse
}
