import AdminOpenAPI

struct AdminRemoveNewsletterCampaignOpenAPIRepository {
    let api: AdminAPI
    func remove(id: String) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api).remove(id: id)
    }
    func remove(ids: [String]) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api)
            .bulkRemove(ids: ids)
    }
}
