import AdminOpenAPI

struct AdminListNewsletterCampaignsOpenAPIRepository {
    let api: AdminAPI

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await AdminNewsletterCampaignAPIClient(api: api).list()
    }
}
