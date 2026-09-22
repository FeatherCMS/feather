
struct AdminListNewsletterCampaignsOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await AdminNewsletterCampaignAPIClient(api: api).list()
    }
}
