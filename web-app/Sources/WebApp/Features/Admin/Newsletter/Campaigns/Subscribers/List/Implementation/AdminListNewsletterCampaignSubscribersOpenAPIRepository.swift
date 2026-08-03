import AdminOpenAPI

struct AdminListNewsletterCampaignSubscribersOpenAPIRepository {
    let api: AdminAPI
    func list(newsletterId: String) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .list(newsletterId: newsletterId)
    }
}
