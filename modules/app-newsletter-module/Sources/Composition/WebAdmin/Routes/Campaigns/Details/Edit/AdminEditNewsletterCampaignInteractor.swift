import NewsletterModule

protocol AdminEditNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> Campaign.Item
    func update(
        id: String,
        newKey: String,
        name: String,
        fromEmail: String
    ) async throws
}
