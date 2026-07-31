protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list() async throws -> [AdminNewsletterCampaignItem]
}
