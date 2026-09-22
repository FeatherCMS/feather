
struct AdminRemoveNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func remove(id: String) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api).remove(id: id)
    }
    func remove(ids: [String]) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api)
            .remove(ids: ids)
    }
}
