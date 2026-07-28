struct AdminEditNewsletterCampaignSubscriberDefaultInteractor:
    AdminEditNewsletterCampaignSubscriberInteractor
{
    let repository: AdminEditNewsletterCampaignSubscriberOpenAPIRepository
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await repository.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterSubscriberForm
    ) async throws {
        try await repository.update(
            newsletterId: newsletterId,
            subscriberId: subscriberId,
            form: form
        )
    }
}
