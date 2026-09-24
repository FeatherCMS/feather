protocol AdminEditNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> AdminNewsletterCampaignItem
    func update(id: String, name: String, fromEmail: String) async throws
}
