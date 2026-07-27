protocol AdminManageNewsletterSubscribersInteractor: Sendable {
    func list(newsletterId: String, search: String?) async throws
        -> [AdminManageNewsletterSubscriberItem]
    func create(newsletterId: String, form: NewsletterSubscriberForm)
        async throws
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminManageNewsletterSubscriberItem
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterSubscriberForm
    ) async throws
    func remove(newsletterId: String, subscriberId: String) async throws
    func bulkRemove(newsletterId: String, subscriberIds: [String]) async throws
}
