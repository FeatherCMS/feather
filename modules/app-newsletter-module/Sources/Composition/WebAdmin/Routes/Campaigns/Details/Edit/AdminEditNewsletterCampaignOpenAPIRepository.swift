import NewsletterModule

struct AdminEditNewsletterCampaignOpenAPIRepository {
    let api: API.Client
    func get(id: String) async throws -> Campaign.Item {
        try await Campaign.APIClient(api: api).get(id: id)
    }
    func update(
        id: String,
        newKey: String,
        name: String,
        fromEmail: String
    ) async throws {
        _ = try await Campaign.APIClient(api: api)
            .update(id: id, newKey: newKey, name: name, fromEmail: fromEmail)
    }
}
