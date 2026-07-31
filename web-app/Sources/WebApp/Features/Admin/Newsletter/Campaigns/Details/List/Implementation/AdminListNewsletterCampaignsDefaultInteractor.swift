struct AdminListNewsletterCampaignsDefaultInteractor:
    AdminListNewsletterCampaignsInteractor
{
    let repository: AdminListNewsletterCampaignsOpenAPIRepository

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await repository.list()
    }
}
