import AdminOpenAPI

struct AdminGetNewsletterCampaignOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await AdminNewsletterCampaignAPIClient(api: api).get(id: id)
    }
}
