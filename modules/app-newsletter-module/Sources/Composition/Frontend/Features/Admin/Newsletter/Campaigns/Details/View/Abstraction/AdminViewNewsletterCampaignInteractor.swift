protocol AdminViewNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> AdminNewsletterCampaignItem
}
