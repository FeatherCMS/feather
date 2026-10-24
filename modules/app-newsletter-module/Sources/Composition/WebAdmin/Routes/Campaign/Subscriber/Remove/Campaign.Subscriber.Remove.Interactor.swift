import NewsletterModule

extension Campaign.Subscriber.Remove {
    enum Interactor {}
}

extension Campaign.Subscriber.Remove.Interactor {
    protocol Interface: Sendable {
        func remove(newsletterId: String, subscriberIds: [String]) async throws
    }
}
