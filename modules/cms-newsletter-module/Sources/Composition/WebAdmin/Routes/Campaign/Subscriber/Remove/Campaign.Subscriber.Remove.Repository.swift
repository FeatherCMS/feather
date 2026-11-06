import NewsletterApplication
import NewsletterModule

extension Campaign.Subscriber.Remove {
    enum Repository {}
}

extension Campaign.Subscriber.Remove.Repository {
    protocol Interface: Sendable {
        func remove(newsletterId: String, subscriberIds: [String]) async throws
    }
}
