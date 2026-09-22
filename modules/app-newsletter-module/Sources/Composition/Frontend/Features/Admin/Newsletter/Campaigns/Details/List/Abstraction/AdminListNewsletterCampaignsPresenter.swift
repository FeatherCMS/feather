import FeatherAdmin

protocol AdminListNewsletterCampaignsPresenter: Sendable {
    func render(
        model: NewAdminListModel<AdminNewsletterCampaignItem>,
        isPicker: Bool,
        error: String?,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse
}
