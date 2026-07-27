protocol AdminEditNewsletterCampaignSubscriberInteractor: Sendable {
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterSubscriberForm
    ) async throws
}
