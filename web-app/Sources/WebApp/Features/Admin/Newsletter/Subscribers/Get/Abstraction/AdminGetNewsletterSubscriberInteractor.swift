protocol AdminGetNewsletterSubscriberInteractor: Sendable {
    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
}
