import FeatherAdmin

protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<AdminNewsletterCampaignItem>
}
