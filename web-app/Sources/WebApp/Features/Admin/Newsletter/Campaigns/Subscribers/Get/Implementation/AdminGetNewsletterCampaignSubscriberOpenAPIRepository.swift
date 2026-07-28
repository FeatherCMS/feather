import AdminOpenAPI

struct AdminGetNewsletterCampaignSubscriberOpenAPIRepository {
    let api: AdminAPI
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .get(newsletterId: newsletterId, subscriberId: subscriberId)
    }
}
