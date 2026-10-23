import NewsletterModule

protocol AdminViewNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> Campaign.Item
}
