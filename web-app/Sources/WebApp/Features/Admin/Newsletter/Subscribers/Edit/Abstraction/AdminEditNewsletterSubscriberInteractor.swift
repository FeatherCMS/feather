protocol AdminEditNewsletterSubscriberInteractor: Sendable {
    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
    func update(
        subscriberId: String,
        newsletterId: String?,
        form: NewsletterSubscriberForm
    ) async throws -> AdminGetNewsletterSubscriberModel
}
