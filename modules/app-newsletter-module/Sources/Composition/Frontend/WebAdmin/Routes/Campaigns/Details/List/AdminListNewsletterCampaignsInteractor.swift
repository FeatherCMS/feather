import FeatherWebAdmin

protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<AdminNewsletterCampaignItem>
}
