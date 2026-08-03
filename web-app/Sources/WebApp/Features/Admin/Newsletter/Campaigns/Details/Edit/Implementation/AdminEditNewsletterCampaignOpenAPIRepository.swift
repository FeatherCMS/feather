import AdminOpenAPI

struct AdminEditNewsletterCampaignOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await AdminNewsletterCampaignAPIClient(api: api).get(id: id)
    }
    func update(id: String, name: String, fromEmail: String) async throws {
        _ = try await AdminNewsletterCampaignAPIClient(api: api)
            .update(id: id, name: name, fromEmail: fromEmail)
    }
}
