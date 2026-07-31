import AdminOpenAPI

struct AdminRemoveNewsletterCampaignSubscriberOpenAPIRepository {
    let api: AdminAPI
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .get(newsletterId: newsletterId, subscriberId: subscriberId)
    }
    func remove(newsletterId: String, subscriberId: String) async throws {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .remove(newsletterId: newsletterId, subscriberId: subscriberId)
    }
    func remove(newsletterId: String, subscriberIds: [String]) async throws {
        for subscriberId in subscriberIds {
            try await remove(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
        }
    }
}
