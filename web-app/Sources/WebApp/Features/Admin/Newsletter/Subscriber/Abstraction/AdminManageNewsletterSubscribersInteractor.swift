protocol AdminManageNewsletterSubscribersInteractor: Sendable {
    func list(newsletterId: String, search: String?) async throws -> [AdminManageNewsletterSubscriberItem]
    func create(newsletterId: String, form: NewsletterSubscriberForm) async throws
    func get(newsletterId: String, email: String) async throws -> AdminManageNewsletterSubscriberItem
    func update(newsletterId: String, email: String, form: NewsletterSubscriberForm) async throws
    func remove(newsletterId: String, email: String) async throws
    func bulkRemove(newsletterId: String, emails: [String]) async throws
}
