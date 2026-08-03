import AdminOpenAPI

struct AdminEditNewsletterSubscriberOpenAPIRepository {
    let api: AdminAPI

    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
    {
        try await AdminGetNewsletterSubscriberOpenAPIRepository(api: api)
            .get(subscriberId: subscriberId, newsletterId: newsletterId)
    }

    func update(
        subscriberId: String,
        newsletterId: String?,
        form: NewsletterSubscriberForm
    ) async throws -> AdminGetNewsletterSubscriberModel {
        let model = try await get(
            subscriberId: subscriberId,
            newsletterId: newsletterId
        )
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .update(
                newsletterId: model.newsletterId,
                subscriberId: subscriberId,
                form: form
            )
        return try await get(
            subscriberId: subscriberId,
            newsletterId: model.newsletterId
        )
    }
}
