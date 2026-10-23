import NewsletterModule

struct AdminRemoveNewsletterCampaignOpenAPIRepository {
    let api: API.Client
    func remove(id: String) async throws {
        try await Campaign.APIClient(api: api).remove(id: id)
    }
    func remove(ids: [String]) async throws {
        try await Campaign.APIClient(api: api)
            .remove(ids: ids)
    }
}
