import AdminOpenAPI

struct AdminEditNewsletterCampaignSubscriberOpenAPIRepository {
    let api: AdminAPI
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .get(newsletterId: newsletterId, subscriberId: subscriberId)
    }
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterSubscriberForm
    ) async throws {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .update(
                newsletterId: newsletterId,
                subscriberId: subscriberId,
                form: form
            )
    }
}
