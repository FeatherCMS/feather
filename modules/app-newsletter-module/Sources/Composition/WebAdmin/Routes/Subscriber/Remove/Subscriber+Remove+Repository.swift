import NewsletterModule
import NewsletterApplication

extension Subscriber.Remove.Repository {
    protocol Interface: Sendable {
        func remove(ids: [String], campaignId: String?) async throws
    }
}
