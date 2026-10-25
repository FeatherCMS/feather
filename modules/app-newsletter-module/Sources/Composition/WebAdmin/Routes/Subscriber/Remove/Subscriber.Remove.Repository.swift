import NewsletterApplication
import NewsletterModule

extension Subscriber.Remove {
    enum Repository {}
}

extension Subscriber.Remove.Repository {
    protocol Interface: Sendable {
        func remove(ids: [String], campaignId: String?) async throws
    }
}
